Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from smtpauth01.csee.siteprotect.eu ([83.246.86.180])
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <roger@beardandsandals.co.uk>) id 1KazmZ-00082s-BD
	for linux-dvb@linuxtv.org; Wed, 03 Sep 2008 23:20:55 +0200
Received: from [192.168.10.241] (unknown [81.168.109.249])
	(Authenticated sender: roger@beardandsandals.co.uk)
	by smtpauth01.csee.siteprotect.eu (Postfix) with ESMTP id 590CC6C007
	for <linux-dvb@linuxtv.org>; Wed,  3 Sep 2008 23:20:20 +0200 (CEST)
Message-ID: <48BEFF95.1080601@beardandsandals.co.uk>
Date: Wed, 03 Sep 2008 22:20:21 +0100
From: Roger James <roger@beardandsandals.co.uk>
MIME-Version: 1.0
To: linux-dvb@linuxtv.org
References: <48BD78B0.6070508@beardandsandals.co.uk>	<48BD85FC.6030800@kipdola.com>	<48BD96F9.2010901@beardandsandals.co.uk>
	<48BD9CF0.9080604@beardandsandals.co.uk>
In-Reply-To: <48BD9CF0.9080604@beardandsandals.co.uk>
Subject: Re: [linux-dvb] Help - trying to get multiproto TT03200 driver
 working via old API
List-Unsubscribe: <http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb>,
	<mailto:linux-dvb-request@linuxtv.org?subject=unsubscribe>
List-Archive: <http://www.linuxtv.org/pipermail/linux-dvb>
List-Post: <mailto:linux-dvb@linuxtv.org>
List-Help: <mailto:linux-dvb-request@linuxtv.org?subject=help>
List-Subscribe: <http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb>,
	<mailto:linux-dvb-request@linuxtv.org?subject=subscribe>
Content-Type: multipart/mixed; boundary="===============0130551578=="
Mime-version: 1.0
Sender: linux-dvb-bounces@linuxtv.org
Errors-To: linux-dvb-bounces+mchehab=infradead.org@linuxtv.org
List-ID: <linux-dvb@linuxtv.org>

--===============0130551578==
Content-Type: text/html; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit

<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
<html>
<head>
  <meta content="text/html;charset=ISO-8859-1" http-equiv="Content-Type">
  <title></title>
</head>
<body bgcolor="#ffffff" text="#000000">
For what it is worth, here is my change to dvb_frontend.c<br>
I would welcome comments on whether I am going about this the right
way, or whether I am wasting my time. I will start testing with this
tomorrow.<br>
<br>
static int dvb_frontend_ioctl(struct inode *inode, struct file *file,<br>
&nbsp;&nbsp;&nbsp; &nbsp;&nbsp;&nbsp; &nbsp;&nbsp;&nbsp; unsigned int cmd, void *parg)<br>
{<br>
...<br>
&nbsp;&nbsp;&nbsp; case FE_SET_FRONTEND: {<br>
&nbsp;&nbsp;&nbsp; &nbsp;&nbsp;&nbsp; struct dvb_frontend_tune_settings fetunesettings;<br>
<br>
&nbsp;&nbsp;&nbsp; &nbsp;&nbsp;&nbsp; if (dvb_frontend_check_parameters(fe, parg) &lt; 0) {<br>
&nbsp;&nbsp;&nbsp; &nbsp;&nbsp;&nbsp; &nbsp;&nbsp;&nbsp; err = -EINVAL;<br>
&nbsp;&nbsp;&nbsp; &nbsp;&nbsp;&nbsp; &nbsp;&nbsp;&nbsp; break;<br>
&nbsp;&nbsp;&nbsp; &nbsp;&nbsp;&nbsp; }<br>
<br>
&nbsp;&nbsp;&nbsp; &nbsp;&nbsp;&nbsp; memcpy(&amp;fepriv-&gt;parameters, parg, sizeof (struct
dvb_frontend_parameters));&nbsp;&nbsp;&nbsp; &nbsp;&nbsp;&nbsp; <br>
&nbsp;&nbsp;&nbsp; &nbsp;&nbsp;&nbsp; if (fe-&gt;legacy) {<br>
&nbsp;&nbsp;&nbsp; &nbsp;&nbsp;&nbsp; &nbsp;&nbsp;&nbsp; memset(&amp;fetunesettings, 0, sizeof(struct
dvb_frontend_tune_settings));<br>
&nbsp;&nbsp;&nbsp; &nbsp;&nbsp;&nbsp; &nbsp;&nbsp;&nbsp; memcpy(&amp;fetunesettings.parameters, parg, sizeof (struct
dvb_frontend_parameters));<br>
<br>
&nbsp;&nbsp;&nbsp; &nbsp;&nbsp;&nbsp; &nbsp;&nbsp;&nbsp; /* force auto frequency inversion if requested */<br>
&nbsp;&nbsp;&nbsp; &nbsp;&nbsp;&nbsp; &nbsp;&nbsp;&nbsp; if (dvb_force_auto_inversion) {<br>
&nbsp;&nbsp;&nbsp; &nbsp;&nbsp;&nbsp; &nbsp;&nbsp;&nbsp; &nbsp;&nbsp;&nbsp; fepriv-&gt;parameters.inversion = INVERSION_AUTO;<br>
&nbsp;&nbsp;&nbsp; &nbsp;&nbsp;&nbsp; &nbsp;&nbsp;&nbsp; &nbsp;&nbsp;&nbsp; fetunesettings.parameters.inversion = INVERSION_AUTO;<br>
&nbsp;&nbsp;&nbsp; &nbsp;&nbsp;&nbsp; &nbsp;&nbsp;&nbsp; }<br>
&nbsp;&nbsp;&nbsp; &nbsp;&nbsp;&nbsp; &nbsp;&nbsp;&nbsp; if (fe-&gt;ops.info.type == FE_OFDM) {<br>
&nbsp;&nbsp;&nbsp; &nbsp;&nbsp;&nbsp; &nbsp;&nbsp;&nbsp; &nbsp;&nbsp;&nbsp; /* without hierarchical coding code_rate_LP is
irrelevant,<br>
&nbsp;&nbsp;&nbsp; &nbsp;&nbsp;&nbsp; &nbsp;&nbsp;&nbsp; &nbsp;&nbsp;&nbsp; &nbsp;* so we tolerate the otherwise invalid FEC_NONE
setting */<br>
&nbsp;&nbsp;&nbsp; &nbsp;&nbsp;&nbsp; &nbsp;&nbsp;&nbsp; &nbsp;&nbsp;&nbsp; if (fepriv-&gt;parameters.u.ofdm.hierarchy_information
== HIERARCHY_NONE &amp;&amp;<br>
&nbsp;&nbsp;&nbsp; &nbsp;&nbsp;&nbsp; &nbsp;&nbsp;&nbsp; &nbsp;&nbsp;&nbsp; &nbsp;&nbsp;&nbsp; fepriv-&gt;parameters.u.ofdm.code_rate_LP ==
FEC_NONE)<br>
&nbsp;&nbsp;&nbsp; &nbsp;&nbsp;&nbsp; &nbsp;&nbsp;&nbsp; &nbsp;&nbsp;&nbsp; &nbsp;&nbsp;&nbsp; fepriv-&gt;parameters.u.ofdm.code_rate_LP =
FEC_AUTO;<br>
&nbsp;&nbsp;&nbsp; &nbsp;&nbsp;&nbsp; &nbsp;&nbsp;&nbsp; }<br>
&nbsp;&nbsp;&nbsp; &nbsp;&nbsp;&nbsp; } else {<br>
&nbsp;&nbsp;&nbsp; &nbsp;&nbsp;&nbsp; &nbsp;&nbsp;&nbsp; if (olddrv_to_newapi(fe, &amp;fepriv-&gt;fe_params,
&amp;fepriv-&gt;parameters, fe-&gt;ops.info.type) == -EINVAL)<br>
&nbsp;&nbsp;&nbsp; &nbsp;&nbsp;&nbsp; &nbsp;&nbsp;&nbsp; &nbsp;&nbsp;&nbsp; printk("%s: ERROR !!! Converting Old parameters --&gt;
New parameters\n", __func__);<br>
&nbsp;&nbsp;&nbsp; &nbsp;&nbsp;&nbsp; &nbsp;&nbsp;&nbsp; memset(&amp;fetunesettings, 0, sizeof (struct
dvb_frontend_tune_settings));<br>
&nbsp;&nbsp;&nbsp; &nbsp;&nbsp;&nbsp; &nbsp;&nbsp;&nbsp; memcpy(&amp;fetunesettings.fe_params,
&amp;fepriv-&gt;fe_params, sizeof (struct dvbfe_params));<br>
<br>
&nbsp;&nbsp;&nbsp; &nbsp;&nbsp;&nbsp; &nbsp;&nbsp;&nbsp; /* Request the search algorithm to search&nbsp;&nbsp;&nbsp; */<br>
&nbsp;&nbsp;&nbsp; &nbsp;&nbsp;&nbsp; &nbsp;&nbsp;&nbsp; fepriv-&gt;algo_status |= DVBFE_ALGO_SEARCH_AGAIN;<br>
<br>
&nbsp;&nbsp;&nbsp; &nbsp;&nbsp;&nbsp; &nbsp;&nbsp;&nbsp; /* force auto frequency inversion if requested */<br>
&nbsp;&nbsp;&nbsp; &nbsp;&nbsp;&nbsp; &nbsp;&nbsp;&nbsp; if (dvb_force_auto_inversion) {<br>
&nbsp;&nbsp;&nbsp; &nbsp;&nbsp;&nbsp; &nbsp;&nbsp;&nbsp; &nbsp;&nbsp;&nbsp; fepriv-&gt;fe_params.inversion = DVBFE_INVERSION_AUTO;<br>
&nbsp;&nbsp;&nbsp; &nbsp;&nbsp;&nbsp; &nbsp;&nbsp;&nbsp; &nbsp;&nbsp;&nbsp; fetunesettings.fe_params.inversion =
DVBFE_INVERSION_AUTO;<br>
&nbsp;&nbsp;&nbsp; &nbsp;&nbsp;&nbsp; &nbsp;&nbsp;&nbsp; }<br>
<br>
&nbsp;&nbsp;&nbsp; &nbsp;&nbsp;&nbsp; &nbsp;&nbsp;&nbsp; if (fe-&gt;ops.get_delsys) {<br>
&nbsp;&nbsp;&nbsp; &nbsp;&nbsp;&nbsp; &nbsp;&nbsp;&nbsp; &nbsp;&nbsp;&nbsp; enum dvbfe_delsys delsys;<br>
&nbsp;&nbsp;&nbsp; &nbsp;&nbsp;&nbsp; &nbsp;&nbsp;&nbsp; &nbsp;&nbsp;&nbsp; fe-&gt;ops.get_delsys(fe, &amp;delsys);<br>
&nbsp;&nbsp;&nbsp; &nbsp;&nbsp;&nbsp; &nbsp;&nbsp;&nbsp; &nbsp;&nbsp;&nbsp; if ((delsys == DVBFE_DELSYS_DVBT) ||<br>
&nbsp;&nbsp;&nbsp; &nbsp;&nbsp;&nbsp; &nbsp;&nbsp;&nbsp; &nbsp;&nbsp;&nbsp; &nbsp;&nbsp;&nbsp; (delsys == DVBFE_DELSYS_DVBH)) {<br>
<br>
&nbsp;&nbsp;&nbsp; &nbsp;&nbsp;&nbsp; &nbsp;&nbsp;&nbsp; &nbsp;&nbsp;&nbsp; &nbsp;&nbsp;&nbsp; /* without hierachical coding code_rate_LP is
irrelevant,<br>
&nbsp;&nbsp;&nbsp; &nbsp;&nbsp;&nbsp; &nbsp;&nbsp;&nbsp; &nbsp;&nbsp;&nbsp; &nbsp;&nbsp;&nbsp; &nbsp;* so we tolerate the otherwise invalid FEC_NONE
setting */<br>
&nbsp;&nbsp;&nbsp; &nbsp;&nbsp;&nbsp; &nbsp;&nbsp;&nbsp; &nbsp;&nbsp;&nbsp; &nbsp;&nbsp;&nbsp; if (fepriv-&gt;fe_params.delsys.dvbt.hierarchy ==
DVBFE_HIERARCHY_OFF &amp;&amp;<br>
&nbsp;&nbsp;&nbsp; &nbsp;&nbsp;&nbsp; &nbsp;&nbsp;&nbsp; &nbsp;&nbsp;&nbsp; &nbsp;&nbsp;&nbsp; &nbsp;&nbsp;&nbsp; fepriv-&gt;fe_params.delsys.dvbt.code_rate_LP
== DVBFE_FEC_NONE)<br>
<br>
&nbsp;&nbsp;&nbsp; &nbsp;&nbsp;&nbsp; &nbsp;&nbsp;&nbsp; &nbsp;&nbsp;&nbsp; &nbsp;&nbsp;&nbsp; &nbsp;&nbsp;&nbsp; fepriv-&gt;fe_params.delsys.dvbt.code_rate_LP =
DVBFE_FEC_AUTO;<br>
&nbsp;&nbsp;&nbsp; &nbsp;&nbsp;&nbsp; &nbsp;&nbsp;&nbsp; &nbsp;&nbsp;&nbsp; }<br>
&nbsp;&nbsp;&nbsp; &nbsp;&nbsp;&nbsp; &nbsp;&nbsp;&nbsp; }<br>
&nbsp;&nbsp;&nbsp; &nbsp;&nbsp;&nbsp; }<br>
<br>
&nbsp;&nbsp;&nbsp; &nbsp;&nbsp;&nbsp; /* get frontend-specific tuning settings */<br>
&nbsp;&nbsp;&nbsp; &nbsp;&nbsp;&nbsp; if (fe-&gt;ops.get_tune_settings &amp;&amp;
(fe-&gt;ops.get_tune_settings(fe, &amp;fetunesettings) == 0)) {<br>
&nbsp;&nbsp;&nbsp; &nbsp;&nbsp;&nbsp; &nbsp;&nbsp;&nbsp; fepriv-&gt;min_delay = (fetunesettings.min_delay_ms * HZ) /
1000;<br>
&nbsp;&nbsp;&nbsp; &nbsp;&nbsp;&nbsp; &nbsp;&nbsp;&nbsp; fepriv-&gt;max_drift = fetunesettings.max_drift;<br>
&nbsp;&nbsp;&nbsp; &nbsp;&nbsp;&nbsp; &nbsp;&nbsp;&nbsp; fepriv-&gt;step_size = fetunesettings.step_size;<br>
&nbsp;&nbsp;&nbsp; &nbsp;&nbsp;&nbsp; } else {<br>
&nbsp;&nbsp;&nbsp; &nbsp;&nbsp;&nbsp; &nbsp;&nbsp;&nbsp; /* default values */<br>
&nbsp;&nbsp;&nbsp; &nbsp;&nbsp;&nbsp; &nbsp;&nbsp;&nbsp; switch(fe-&gt;ops.info.type) {<br>
&nbsp;&nbsp;&nbsp; &nbsp;&nbsp;&nbsp; &nbsp;&nbsp;&nbsp; case FE_QPSK:<br>
&nbsp;&nbsp;&nbsp; &nbsp;&nbsp;&nbsp; &nbsp;&nbsp;&nbsp; &nbsp;&nbsp;&nbsp; fepriv-&gt;min_delay = HZ/20;<br>
&nbsp;&nbsp;&nbsp; &nbsp;&nbsp;&nbsp; &nbsp;&nbsp;&nbsp; &nbsp;&nbsp;&nbsp; fepriv-&gt;step_size =
fepriv-&gt;parameters.u.qpsk.symbol_rate / 16000;<br>
&nbsp;&nbsp;&nbsp; &nbsp;&nbsp;&nbsp; &nbsp;&nbsp;&nbsp; &nbsp;&nbsp;&nbsp; fepriv-&gt;max_drift =
fepriv-&gt;parameters.u.qpsk.symbol_rate / 2000;<br>
&nbsp;&nbsp;&nbsp; &nbsp;&nbsp;&nbsp; &nbsp;&nbsp;&nbsp; &nbsp;&nbsp;&nbsp; break;<br>
<br>
&nbsp;&nbsp;&nbsp; &nbsp;&nbsp;&nbsp; &nbsp;&nbsp;&nbsp; case FE_QAM:<br>
&nbsp;&nbsp;&nbsp; &nbsp;&nbsp;&nbsp; &nbsp;&nbsp;&nbsp; &nbsp;&nbsp;&nbsp; fepriv-&gt;min_delay = HZ/20;<br>
&nbsp;&nbsp;&nbsp; &nbsp;&nbsp;&nbsp; &nbsp;&nbsp;&nbsp; &nbsp;&nbsp;&nbsp; fepriv-&gt;step_size = 0; /* no zigzag */<br>
&nbsp;&nbsp;&nbsp; &nbsp;&nbsp;&nbsp; &nbsp;&nbsp;&nbsp; &nbsp;&nbsp;&nbsp; fepriv-&gt;max_drift = 0;<br>
&nbsp;&nbsp;&nbsp; &nbsp;&nbsp;&nbsp; &nbsp;&nbsp;&nbsp; &nbsp;&nbsp;&nbsp; break;<br>
<br>
&nbsp;&nbsp;&nbsp; &nbsp;&nbsp;&nbsp; &nbsp;&nbsp;&nbsp; case FE_OFDM:<br>
&nbsp;&nbsp;&nbsp; &nbsp;&nbsp;&nbsp; &nbsp;&nbsp;&nbsp; &nbsp;&nbsp;&nbsp; fepriv-&gt;min_delay = HZ/20;<br>
&nbsp;&nbsp;&nbsp; &nbsp;&nbsp;&nbsp; &nbsp;&nbsp;&nbsp; &nbsp;&nbsp;&nbsp; fepriv-&gt;step_size =
fe-&gt;ops.info.frequency_stepsize * 2;<br>
&nbsp;&nbsp;&nbsp; &nbsp;&nbsp;&nbsp; &nbsp;&nbsp;&nbsp; &nbsp;&nbsp;&nbsp; fepriv-&gt;max_drift =
(fe-&gt;ops.info.frequency_stepsize * 2) + 1;<br>
&nbsp;&nbsp;&nbsp; &nbsp;&nbsp;&nbsp; &nbsp;&nbsp;&nbsp; &nbsp;&nbsp;&nbsp; break;<br>
&nbsp;&nbsp;&nbsp; &nbsp;&nbsp;&nbsp; &nbsp;&nbsp;&nbsp; case FE_ATSC:<br>
&nbsp;&nbsp;&nbsp; &nbsp;&nbsp;&nbsp; &nbsp;&nbsp;&nbsp; &nbsp;&nbsp;&nbsp; fepriv-&gt;min_delay = HZ/20;<br>
&nbsp;&nbsp;&nbsp; &nbsp;&nbsp;&nbsp; &nbsp;&nbsp;&nbsp; &nbsp;&nbsp;&nbsp; fepriv-&gt;step_size = 0;<br>
&nbsp;&nbsp;&nbsp; &nbsp;&nbsp;&nbsp; &nbsp;&nbsp;&nbsp; &nbsp;&nbsp;&nbsp; fepriv-&gt;max_drift = 0;<br>
&nbsp;&nbsp;&nbsp; &nbsp;&nbsp;&nbsp; &nbsp;&nbsp;&nbsp; &nbsp;&nbsp;&nbsp; break;<br>
&nbsp;&nbsp;&nbsp; &nbsp;&nbsp;&nbsp; &nbsp;&nbsp;&nbsp; }<br>
&nbsp;&nbsp;&nbsp; &nbsp;&nbsp;&nbsp; }<br>
&nbsp;&nbsp;&nbsp; &nbsp;&nbsp;&nbsp; if (dvb_override_tune_delay &gt; 0)<br>
&nbsp;&nbsp;&nbsp; &nbsp;&nbsp;&nbsp; &nbsp;&nbsp;&nbsp; fepriv-&gt;min_delay = (dvb_override_tune_delay * HZ) /
1000;<br>
<br>
&nbsp;&nbsp;&nbsp; &nbsp;&nbsp;&nbsp; fepriv-&gt;state = FESTATE_RETUNE;<br>
&nbsp;&nbsp;&nbsp; &nbsp;&nbsp;&nbsp; dvb_frontend_wakeup(fe);<br>
&nbsp;&nbsp;&nbsp; &nbsp;&nbsp;&nbsp; dvb_frontend_add_event(fe, 0);<br>
&nbsp;&nbsp;&nbsp; &nbsp;&nbsp;&nbsp; fepriv-&gt;status = 0;<br>
&nbsp;&nbsp;&nbsp; &nbsp;&nbsp;&nbsp; err = 0;<br>
&nbsp;&nbsp;&nbsp; &nbsp;&nbsp;&nbsp; break;<br>
&nbsp;&nbsp;&nbsp; }<br>
<br>
...<br>
<br>
&nbsp;&nbsp;&nbsp; case FE_GET_FRONTEND:<br>
&nbsp;&nbsp;&nbsp; &nbsp;&nbsp;&nbsp; if (fe-&gt;legacy) {<br>
&nbsp;&nbsp;&nbsp; &nbsp;&nbsp;&nbsp; &nbsp;&nbsp;&nbsp; if (fe-&gt;ops.get_frontend) {<br>
&nbsp;&nbsp;&nbsp; &nbsp;&nbsp;&nbsp; &nbsp;&nbsp;&nbsp; &nbsp;&nbsp;&nbsp; memcpy (parg, &amp;fepriv-&gt;parameters, sizeof
(struct dvb_frontend_parameters));<br>
&nbsp;&nbsp;&nbsp; &nbsp;&nbsp;&nbsp; &nbsp;&nbsp;&nbsp; &nbsp;&nbsp;&nbsp; err = fe-&gt;ops.get_frontend(fe, (struct
dvb_frontend_parameters*) parg);<br>
&nbsp;&nbsp;&nbsp; &nbsp;&nbsp;&nbsp; &nbsp;&nbsp;&nbsp; }<br>
&nbsp;&nbsp;&nbsp; &nbsp;&nbsp;&nbsp; } else {<br>
&nbsp;&nbsp;&nbsp; &nbsp;&nbsp;&nbsp; &nbsp;&nbsp;&nbsp; if (fe-&gt;ops.get_params) {<br>
&nbsp;&nbsp;&nbsp; &nbsp;&nbsp;&nbsp; &nbsp;&nbsp;&nbsp; &nbsp;&nbsp;&nbsp; struct dvbfe_params temporary_params;<br>
&nbsp;&nbsp;&nbsp; &nbsp;&nbsp;&nbsp; &nbsp;&nbsp;&nbsp; &nbsp;&nbsp;&nbsp; memcpy(&amp;temporary_params,
&amp;fepriv-&gt;fe_params, sizeof (struct dvbfe_params));<br>
&nbsp;&nbsp;&nbsp; &nbsp;&nbsp;&nbsp; &nbsp;&nbsp;&nbsp; &nbsp;&nbsp;&nbsp; err = fe-&gt;ops.get_params(fe, &amp;temporary_params);<br>
&nbsp;&nbsp;&nbsp; &nbsp;&nbsp;&nbsp; &nbsp;&nbsp;&nbsp; &nbsp;&nbsp;&nbsp; if (newapi_to_olddrv(&amp;temporary_params, (struct
dvb_frontend_parameters*) parg, fepriv-&gt;delsys)&nbsp; == -EINVAL)<br>
&nbsp;&nbsp;&nbsp; &nbsp;&nbsp;&nbsp; &nbsp;&nbsp;&nbsp; &nbsp;&nbsp;&nbsp; &nbsp;&nbsp;&nbsp; printk("%s: ERROR !!! Converting New parameters
--&gt; Old parameters\n", __func__);<br>
&nbsp;&nbsp;&nbsp; &nbsp;&nbsp;&nbsp; &nbsp;&nbsp;&nbsp; }<br>
&nbsp;&nbsp;&nbsp; &nbsp;&nbsp;&nbsp; }<br>
&nbsp;&nbsp;&nbsp; &nbsp;&nbsp;&nbsp; break;<br>
<br>
Roger<br>
<br>
Roger James wrote:
<blockquote cite="mid:48BD9CF0.9080604@beardandsandals.co.uk"
 type="cite">
  <meta content="text/html;charset=ISO-8859-1" http-equiv="Content-Type">
  <title></title>
Hmm,<br>
  <br>
Looking at this further. I think the patch will break compatibility
with all the old non multi-protocol drivers. That is the last thing I
want to do. What is needed is something that converts to the new api
only when needed. I wonder if there is a simple test to see if the
underlying driver is old or new.<br>
  <br>
I am somewhat out of my depth here!<br>
  <br>
I am beginning to think I should have bought a DVB-S card after all.
Especially as none of the services I want to view are S2!<br>
  <br>
Roger<br>
  <br>
Roger James wrote:
  <blockquote cite="mid:48BD96F9.2010901@beardandsandals.co.uk"
 type="cite">
    <meta content="text/html;charset=ISO-8859-1"
 http-equiv="Content-Type">
    <title></title>
Thanks,<br>
    <br>
Looking at the patch diff is does not appear too complex. I will try
and see if I can work out a minimal patch against the current tree. If
not I will fall back on your suggestion. I think it would be desireable
if what makes it into the kernel supports new cards been driven in the
old way. <br>
    <br>
Roger<br>
    <br>
Jelle De Loecker wrote:
    <blockquote cite="mid:48BD85FC.6030800@kipdola.com" type="cite">
      <meta content="text/html;charset=ISO-8859-1"
 http-equiv="Content-Type">
      <title></title>
I feel your pain, patch-hell isn't a fun place to be :)<br>
      <br>
Lots of people make guides on how to fix something, unfortunately they
forget that trees grow, and a patch that works today probably won't
work tomorrow.<br>
Thankfully you can check out different revisions!<br>
      <br>
I'd sugest you try this patch out on manu's original multiproto tree,
revision number 7213 (that was the last update, in april, before she
made her patch)<br>
      <br>
hg clone -r 7213 <a moz-do-not-send="true"
 class="moz-txt-link-freetext" href="http://jusst.de/hg/multiproto">http://jusst.de/hg/multiproto</a><br>
      <div class="moz-signature"><br>
      <em>Met vriendelijke groeten,</em> <br>
      <br>
      <strong>Jelle De Loecker</strong> <br>
Kipdola Studios - Tomberg <br>
      </div>
      <br>
      <br>
Roger James schreef:
      <blockquote cite="mid:48BD78B0.6070508@beardandsandals.co.uk"
 type="cite">I am have been trying to get gnutv to drive the TT-3200
driver using
the old api (gnutv uses dvb-apps/lib which is not patched for multi
proto). After much head scratching I realised that the fialure of the
driver to get lock when exercised in this way seemed to be related to
DVBFE_ALGO_SEARCH_AGAIN not being set when the FE_SET_FRONTEND ioctl
path was followed rather than than the DVBFE_SET_PARAMS path. A search
of the list revealed that Anssi Hannula had already worked this out and
made a patch (<a moz-do-not-send="true" class="moz-txt-link-freetext"
 href="http://www.spinics.net/lists/linux-dvb/msg26174.html">http://www.spinics.net/lists/linux-dvb/msg26174.html</a>).
However it does not look like this patch has made it into the code that
Manu has asked to be merged into the kernel. Does this mean that the
merged code will not be compatible with applications such as gnutv
which use dvb-apps/lib or other apps which use the old api?<br>
        <br>
To help me carry on with my testing. Is there as version of Anssi's
patch that can be applied against a recent clone of Manu's code.<br>
        <br>
I apologise if this has been visited before; but I am finding it
virtually impossible to unravel the complexities of what patch matches
what tree.<br>
        <br>
Help<br>
        <br>
Roger<br>
        <pre wrap=""><hr size="4" width="90%">
_______________________________________________
linux-dvb mailing list
<a moz-do-not-send="true" class="moz-txt-link-abbreviated"
 href="mailto:linux-dvb@linuxtv.org">linux-dvb@linuxtv.org</a>
<a moz-do-not-send="true" class="moz-txt-link-freetext"
 href="http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb">http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb</a></pre>
      </blockquote>
    </blockquote>
    <br>
    <pre wrap=""><hr size="4" width="90%">
_______________________________________________
linux-dvb mailing list
<a moz-do-not-send="true" class="moz-txt-link-abbreviated"
 href="mailto:linux-dvb@linuxtv.org">linux-dvb@linuxtv.org</a>
<a moz-do-not-send="true" class="moz-txt-link-freetext"
 href="http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb">http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb</a></pre>
  </blockquote>
  <br>
  <pre wrap="">
<hr size="4" width="90%">
_______________________________________________
linux-dvb mailing list
<a class="moz-txt-link-abbreviated" href="mailto:linux-dvb@linuxtv.org">linux-dvb@linuxtv.org</a>
<a class="moz-txt-link-freetext" href="http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb">http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb</a></pre>
</blockquote>
<br>
</body>
</html>


--===============0130551578==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
--===============0130551578==--
