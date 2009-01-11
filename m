Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from imo-d20.mx.aol.com ([205.188.139.136])
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <dbox2alpha@netscape.net>) id 1LM4Ol-0006GQ-C2
	for linux-dvb@linuxtv.org; Sun, 11 Jan 2009 18:46:56 +0100
Received: from dbox2alpha@netscape.net
	by imo-d20.mx.aol.com  (mail_out_v39.1.) id m.cd3.4b1cccb8 (37568)
	for <linux-dvb@linuxtv.org>; Sun, 11 Jan 2009 12:46:16 -0500 (EST)
References: <20090111093703.GA20152@tangens.sinus.cz>
To: linux-dvb@linuxtv.org
Date: Sun, 11 Jan 2009 12:46:14 -0500
In-Reply-To: <20090111093703.GA20152@tangens.sinus.cz>
MIME-Version: 1.0
From: dbox2alpha@netscape.net
Message-Id: <8CB422BA1BF8E12-1208-865@WEBMAIL-DG13.sim.aol.com>
Subject: Re: [linux-dvb] S2API: Problem with 64/32bit compatibility
List-Unsubscribe: <http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb>,
	<mailto:linux-dvb-request@linuxtv.org?subject=unsubscribe>
List-Archive: <http://www.linuxtv.org/pipermail/linux-dvb>
List-Post: <mailto:linux-dvb@linuxtv.org>
List-Help: <mailto:linux-dvb-request@linuxtv.org?subject=help>
List-Subscribe: <http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb>,
	<mailto:linux-dvb-request@linuxtv.org?subject=subscribe>
Content-Type: multipart/mixed; boundary="===============1033039267=="
Mime-version: 1.0
Sender: linux-dvb-bounces@linuxtv.org
Errors-To: linux-dvb-bounces+mchehab=infradead.org@linuxtv.org
List-ID: <linux-dvb@linuxtv.org>


--===============1033039267==
Content-Type: multipart/alternative;
 boundary="--------MB_8CB422BA1C452C8_1208_115B_WEBMAIL-DG13.sim.aol.com"


----------MB_8CB422BA1C452C8_1208_115B_WEBMAIL-DG13.sim.aol.com
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset="us-ascii"


 hi, 
i ran into the same problem... and would like to have it fixed as well :-)


 Thanks.


 

-----Original Message-----
From: Pavel Troller <patrol@sinus.cz>
To: linux-dvb@linuxtv.org
Sent: Sun, 11 Jan 2009 10:37 am
Subject: [linux-dvb] S2API: Problem with 64/32bit compatibility










Hi!
  I would like to report a problem with S2API. It looks that it doesn't
maintain 64/32bit compatibility.
  It began with my attempt to run the SVN version of kaffeine on linux-2.6.28.
  My system is a 64bit GNU/Linux, but, for historical reasons, I'm still using
32bit KDE 3.5.10, so kaffeine has been compiled as a 32bit binary.
  I've found that I cannot play DVB on this combination. It's because the
FE_SET_PROPERTY ioctl is not properly handled in the kernel.
  After a lot of analysis of both kaffeine and kernel source code, I've found
that the core of the problem is in /usr/src/linux/include/linux/dvb/frontend.h,
where the ioctl is declared. There, a struct dtv_properties is declared:

struct dtv_properties {
        __u32 num;
        struct dtv_property *props;
};

  This struct is then used as a data entry in the FE_SET_PROPERTY ioctl.
  The problem is, that the pointer has different sizes on 32 and 64bit
architectures, so the whole struct differs in size too. And because the size
is passed as a part of the ioctl command code, the FE_SET_PROPERTY (and
FE_GET_PROPERTY too) command codes differ for 32/64 bit compilation of the
same include file! For example, for FE_SET_PROPERTY, its 0x40106f52 on 64bit,
but 0x40086f52 on 32bit. So, the kernel (having the 64bit code inside) cannot
recognize the 32bit code of the cmd and fails to handle it correctly.
  The second part is that these ioctls are not yet added to the 
/usr/src/linux/fs/compat_ioctl.c file, maybe just because of the problem above.

  Are there plans to fix this problem ? I think that 64/32bit compatibility
should be fully maintained, I think that my case is not so rare yet.

  With regards, Pavel Troller   

_______________________________________________
linux-dvb users mailing list
For V4L/DVB development, please use instead linux-media@vger.kernel.org
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb



 


----------MB_8CB422BA1C452C8_1208_115B_WEBMAIL-DG13.sim.aol.com
Content-Transfer-Encoding: 7bit
Content-Type: text/html; charset="us-ascii"


<div> <font face="Arial, Helvetica, sans-serif">hi, <br>
i ran into the same problem... and would like to have it fixed as well :-)<br>
</font></div>

<div> <font face="Arial, Helvetica, sans-serif">Thanks.</font><br>
</div>

<div> <br>
</div>
-----Original Message-----<br>
From: Pavel Troller &lt;patrol@sinus.cz&gt;<br>
To: linux-dvb@linuxtv.org<br>
Sent: Sun, 11 Jan 2009 10:37 am<br>
Subject: [linux-dvb] S2API: Problem with 64/32bit compatibility<br>
<br>






<div id="AOLMsgPart_0_9ae4b164-f467-4f96-b749-0a5d3c56021f" style="margin: 0px; font-family: Tahoma,Verdana,Arial,Sans-Serif; font-size: 12px; color: rgb(0, 0, 0); background-color: rgb(255, 255, 255);">

<pre style="font-size: 9pt;"><tt>Hi!<br>
  I would like to report a problem with S2API. It looks that it doesn't<br>
maintain 64/32bit compatibility.<br>
  It began with my attempt to run the SVN version of kaffeine on linux-2.6.28.<br>
  My system is a 64bit GNU/Linux, but, for historical reasons, I'm still using<br>
32bit KDE 3.5.10, so kaffeine has been compiled as a 32bit binary.<br>
  I've found that I cannot play DVB on this combination. It's because the<br>
FE_SET_PROPERTY ioctl is not properly handled in the kernel.<br>
  After a lot of analysis of both kaffeine and kernel source code, I've found<br>
that the core of the problem is in /usr/src/linux/include/linux/dvb/frontend.h,<br>
where the ioctl is declared. There, a struct dtv_properties is declared:<br>
<br>
struct dtv_properties {<br>
        __u32 num;<br>
        struct dtv_property *props;<br>
};<br>
<br>
  This struct is then used as a data entry in the FE_SET_PROPERTY ioctl.<br>
  The problem is, that the pointer has different sizes on 32 and 64bit<br>
architectures, so the whole struct differs in size too. And because the size<br>
is passed as a part of the ioctl command code, the FE_SET_PROPERTY (and<br>
FE_GET_PROPERTY too) command codes differ for 32/64 bit compilation of the<br>
same include file! For example, for FE_SET_PROPERTY, its 0x40106f52 on 64bit,<br>
but 0x40086f52 on 32bit. So, the kernel (having the 64bit code inside) cannot<br>
recognize the 32bit code of the cmd and fails to handle it correctly.<br>
  The second part is that these ioctls are not yet added to the <br>
/usr/src/linux/fs/compat_ioctl.c file, maybe just because of the problem above.<br>
<br>
  Are there plans to fix this problem ? I think that 64/32bit compatibility<br>
should be fully maintained, I think that my case is not so rare yet.<br>
<br>
  With regards, Pavel Troller   <br>
<br>
_______________________________________________<br>
linux-dvb users mailing list<br>
For V4L/DVB development, please use instead <a __removedlink__1901802240__href="mailto:linux-media@vger.kernel.org">linux-media@vger.kernel.org</a><br>
<a __removedlink__1901802240__href="mailto:linux-dvb@linuxtv.org">linux-dvb@linuxtv.org</a><br>
<a __removedlink__1901802240__href="http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb" target="_blank">http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb</a><br>
</tt></pre>
</div>
 <!-- end of AOLMsgPart_0_9ae4b164-f467-4f96-b749-0a5d3c56021f -->

<div id='MAILCIAMB045-5bc7496a30665c' class='aol_ad_footer'><BR/><FONT style="color: black; font: normal 10pt ARIAL, SAN-SERIF;"><HR style="MARGIN-TOP: 10px"></HR><b>A Good Credit Score is 700 or Above. <a href="http://pr.atwola.com/promoclk/100000075x1216817552x1201106465/aol?redir=http://www.freecreditreport.com/pm/default.aspx?sc=668072%26hmpgID=82%26bcd=DecemailfooterNO82"> See yours in just 2 easy steps!</a></b> </div>

----------MB_8CB422BA1C452C8_1208_115B_WEBMAIL-DG13.sim.aol.com--


--===============1033039267==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
linux-dvb users mailing list
For V4L/DVB development, please use instead linux-media@vger.kernel.org
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
--===============1033039267==--
