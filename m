Return-path: <linux-dvb-bounces@linuxtv.org>
Received: from rn-out-0910.google.com ([64.233.170.191])
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <stburghardt@gmail.com>) id 1JMR38-0002Nr-El
	for linux-dvb@linuxtv.org; Tue, 05 Feb 2008 17:53:34 +0100
Received: by rn-out-0910.google.com with SMTP id j40so913991rnf.20
	for <linux-dvb@linuxtv.org>; Tue, 05 Feb 2008 08:53:33 -0800 (PST)
Message-ID: <5c080cd10802050755w17b1cff2g6ca2a522e73e70d7@mail.gmail.com>
Date: Tue, 5 Feb 2008 08:55:28 -0700
From: "Stanley burghardt" <stburghardt@gmail.com>
To: linux-dvb@linuxtv.org
MIME-Version: 1.0
Subject: [linux-dvb] Nova-s plus
List-Unsubscribe: <http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb>,
	<mailto:linux-dvb-request@linuxtv.org?subject=unsubscribe>
List-Archive: <http://www.linuxtv.org/pipermail/linux-dvb>
List-Post: <mailto:linux-dvb@linuxtv.org>
List-Help: <mailto:linux-dvb-request@linuxtv.org?subject=help>
List-Subscribe: <http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb>,
	<mailto:linux-dvb-request@linuxtv.org?subject=subscribe>
Content-Type: multipart/mixed; boundary="===============0782241046=="
Mime-version: 1.0
Sender: linux-dvb-bounces@linuxtv.org
Errors-To: linux-dvb-bounces@linuxtv.org
List-ID: <linux-dvb@linuxtv.org>

--===============0782241046==
Content-Type: multipart/alternative;
	boundary="----=_Part_6986_29821709.1202226928456"

------=_Part_6986_29821709.1202226928456
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

I saw same topic on the list. Did anyone had solved the problem with nova-s
plus not locking. I use 2.6.24 and latest HG tree and my other cx88 base
card works just fine but nova-s plus shows strenght of 98% but signal
noise goes up and down and there is no lock on it. It Works just fine  with
other cards. I saw  this patch does it realy disable the voltage protection
on nova-s?
Are there any patches that I can test get my  nova-s working ?
*** linux/drivers/media/dvb/frontends/isl6421.c     2006-11-25 23:05:
44.000000000 +0100
--- linux/drivers/media/dvb/frontends/isl6421.c 2006-11-25 23:44:
11.000000000 +0100
***************
*** 44,49 ****
--- 44,51 ----
        u8                      i2c_addr;
  };

+ static int dcl=1; // dynamic current limit on/off, default on
+
  static int isl6421_set_voltage(struct dvb_frontend *fe, fe_sec_voltage_t
voltage)
  {
        struct isl6421 *isl6421 = (struct isl6421 *) fe->sec_priv;
***************
*** 109,114 ****
--- 111,117 ----

        /* default configuration */
        isl6421->config = ISL6421_ISEL1;
+       if (! dcl) isl6421->config |= ISL6421_DCL;
        isl6421->i2c = i2c;
        isl6421->i2c_addr = i2c_addr;
        fe->sec_priv = isl6421;
***************
*** 134,139 ****
--- 137,145 ----

        return fe;
  }
+ module_param(dcl, int, 0644);
+ MODULE_PARM_DESC(dcl, "Turn on/off dynamic current limit (default:on).");
+
  EXPORT_SYMBOL(isl6421_attach);

  MODULE_DESCRIPTION("Driver for lnb supply and control ic isl6421");

------=_Part_6986_29821709.1202226928456
Content-Type: text/html; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

<div>I saw same topic on the list. Did anyone had solved the problem with nova-s plus not locking. I use 2.6.24 and latest HG tree and my other cx88 base card works just fine but nova-s plus shows strenght of 98%&nbsp;but signal noise&nbsp;goes up and down and there is no lock on it. It Works just fine &nbsp;with other cards. I saw&nbsp; this patch does it realy disable the voltage protection on nova-s?</div>

<div>Are there any patches that I can test get my&nbsp; nova-s working ?</div>
<div>*** linux/drivers/media/dvb/frontends/isl6421.c&nbsp;&nbsp;&nbsp;&nbsp; 2006-11-25 23:05:44.000000000 +0100<br>--- linux/drivers/media/dvb/frontends/isl6421.c 2006-11-25 23:44:11.000000000 +0100<br>***************<br>*** 44,49 ****<br>
--- 44,51 ----<br>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; u8&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; i2c_addr;<br>&nbsp; };<br><br>+ static int dcl=1; // dynamic current limit on/off, default on<br>+<br>&nbsp; static int isl6421_set_voltage(struct dvb_frontend *fe, fe_sec_voltage_t voltage)<br>
&nbsp; {<br>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; struct isl6421 *isl6421 = (struct isl6421 *) fe-&gt;sec_priv;<br>***************<br>*** 109,114 ****<br>--- 111,117 ----<br><br>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; /* default configuration */<br>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; isl6421-&gt;config = ISL6421_ISEL1;<br>
+&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; if (! dcl) isl6421-&gt;config |= ISL6421_DCL;<br>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; isl6421-&gt;i2c = i2c;<br>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; isl6421-&gt;i2c_addr = i2c_addr;<br>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; fe-&gt;sec_priv = isl6421;<br>***************<br>*** 134,139 ****<br>--- 137,145 ----<br>
<br>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; return fe;<br>&nbsp; }<br>+ module_param(dcl, int, 0644);<br>+ MODULE_PARM_DESC(dcl, &quot;Turn on/off dynamic current limit (default:on).&quot;);<br>+<br>&nbsp; EXPORT_SYMBOL(isl6421_attach);<br><br>&nbsp; MODULE_DESCRIPTION(&quot;Driver for lnb supply and control ic isl6421&quot;);<br>
<br>&nbsp;</div>

------=_Part_6986_29821709.1202226928456--


--===============0782241046==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
--===============0782241046==--
