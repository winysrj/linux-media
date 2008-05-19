Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from wx-out-0506.google.com ([66.249.82.238])
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <moreau.steve@gmail.com>) id 1Jy6Rp-0007CT-VA
	for linux-dvb@linuxtv.org; Mon, 19 May 2008 16:34:47 +0200
Received: by wx-out-0506.google.com with SMTP id h27so1533761wxd.17
	for <linux-dvb@linuxtv.org>; Mon, 19 May 2008 07:34:40 -0700 (PDT)
Message-ID: <bbc1085f0805190734l230560d5na42ad66a73d1077@mail.gmail.com>
Date: Mon, 19 May 2008 16:34:40 +0200
From: "Steve Moreau" <moreau.steve@gmail.com>
To: linux-dvb <linux-dvb@linuxtv.org>
MIME-Version: 1.0
Subject: [linux-dvb] TS discontinuity
List-Unsubscribe: <http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb>,
	<mailto:linux-dvb-request@linuxtv.org?subject=unsubscribe>
List-Archive: <http://www.linuxtv.org/pipermail/linux-dvb>
List-Post: <mailto:linux-dvb@linuxtv.org>
List-Help: <mailto:linux-dvb-request@linuxtv.org?subject=help>
List-Subscribe: <http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb>,
	<mailto:linux-dvb-request@linuxtv.org?subject=subscribe>
Content-Type: multipart/mixed; boundary="===============0442147153=="
Mime-version: 1.0
Sender: linux-dvb-bounces@linuxtv.org
Errors-To: linux-dvb-bounces+mchehab=infradead.org@linuxtv.org
List-ID: <linux-dvb@linuxtv.org>

--===============0442147153==
Content-Type: multipart/alternative;
	boundary="----=_Part_13705_25913944.1211207680376"

------=_Part_13705_25913944.1211207680376
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

Hi everyone,

I'm experimenting some problems with my DVB-S KNC-One card.
Here is my configuration:

- a DVB-S KNC-One card (subvendor: 1894, subdedvice: 001b) connected to an
output of an 8 ports DiSEqC switch
- previous switch connected to Astra 13E and Hotbird 19E with each tuple
Polarity/Band raising to parabolas (VL,VH,HL,HH) ie. 8 cables.

Whatever transponder I choose to lock to, I got discontinuity in the
transport stream. Someone told me he already found information about such a
problem with KNC-One card, and clues may be to control voltage through
switch.

Has someone already got such issue with this card ?
Thanks, and see you !

Steve

PS : Here is modules loaded by budget_av

        case SUBID_DVBS_TV_STAR:
        case SUBID_DVBS_TV_STAR_CI:
        case SUBID_DVBS_CYNERGY1200N:
        case SUBID_DVBS_EASYWATCH:
        case SUBID_DVBS_EASYWATCH_2:
                fe = dvb_attach(stv0299_attach, &philips_sd1878_config,
                                &budget_av->budget.i2c_adap);
                if (fe) {
                        fe->ops.tuner_ops.set_params =
philips_sd1878_tda8261_tuner_set_params;
                }
                break;

------=_Part_13705_25913944.1211207680376
Content-Type: text/html; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

Hi everyone,<br><br>I&#39;m experimenting some problems with my DVB-S KNC-One card.<br>Here is my configuration:<br><br>- a DVB-S KNC-One card (subvendor: <code>1894</code>, subdedvice: <code>001b)</code> connected to an output of an 8 ports DiSEqC switch<br>
- previous switch connected to Astra 13E and Hotbird 19E with each tuple Polarity/Band raising to parabolas (VL,VH,HL,HH) ie. 8 cables.<br><br>Whatever transponder I choose to lock to, I got discontinuity in the transport stream. Someone told me he already found information about such a problem with KNC-One card, and clues may be to control voltage through switch.<br>
<br>Has someone already got such issue with this card ?<br>Thanks, and see you !<br><br>Steve<br><br>PS : Here is modules loaded by budget_av<br><br>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; case SUBID_DVBS_TV_STAR:<br>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; case SUBID_DVBS_TV_STAR_CI:<br>
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; case SUBID_DVBS_CYNERGY1200N:<br>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; case SUBID_DVBS_EASYWATCH:<br>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; case SUBID_DVBS_EASYWATCH_2:<br>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; fe = dvb_attach(stv0299_attach, &amp;philips_sd1878_config,<br>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; &amp;budget_av-&gt;budget.i2c_adap);<br>
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; if (fe) {<br>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; fe-&gt;ops.tuner_ops.set_params = philips_sd1878_tda8261_tuner_set_params;<br>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; }<br>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; break;<br><br>

------=_Part_13705_25913944.1211207680376--


--===============0442147153==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
--===============0442147153==--
