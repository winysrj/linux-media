Return-path: <mchehab@pedra>
Received: from mail.tu-berlin.de ([130.149.7.33])
	by www.linuxtv.org with esmtp (Exim 4.69)
	(envelope-from <silvercordiagsr@hotmail.com>) id 1QP48S-0003xX-Um
	for linux-dvb@linuxtv.org; Wed, 25 May 2011 04:47:49 +0200
Received: from snt0-omc2-s6.snt0.hotmail.com ([65.55.90.81])
	by mail.tu-berlin.de (exim-4.75/mailfrontend-4) with esmtp
	for <linux-dvb@linuxtv.org>
	id 1QP48S-0001Z2-BM; Wed, 25 May 2011 04:47:48 +0200
Message-ID: <SNT124-W57B15F4522C54494626D8AC740@phx.gbl>
From: Nicholas Leahy <silvercordiagsr@hotmail.com>
To: <linux-media@vger.kernel.org>, <linux-dvb@linuxtv.org>
Date: Wed, 25 May 2011 12:47:45 +1000
In-Reply-To: <4DDB9CA6.6040208@wic.co.nz>
References: <885931.85151.qm@web28303.mail.ukl.yahoo.com>,
	<4DDB9CA6.6040208@wic.co.nz>
MIME-Version: 1.0
Subject: Re: [linux-dvb] build.sh fails on kernel 2.6.38
Reply-To: linux-media@vger.kernel.org
List-Unsubscribe: <http://www.linuxtv.org/cgi-bin/mailman/options/linux-dvb>,
	<mailto:linux-dvb-request@linuxtv.org?subject=unsubscribe>
List-Archive: <http://www.linuxtv.org/pipermail/linux-dvb>
List-Post: <mailto:linux-dvb@linuxtv.org>
List-Help: <mailto:linux-dvb-request@linuxtv.org?subject=help>
List-Subscribe: <http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb>,
	<mailto:linux-dvb-request@linuxtv.org?subject=subscribe>
Content-Type: multipart/mixed; boundary="===============0914161792=="
Errors-To: linux-dvb-bounces+mchehab=infradead.org@linuxtv.org
Sender: <mchehab@pedra>
List-ID: <linux-dvb@linuxtv.org>

--===============0914161792==
Content-Type: multipart/alternative;
	boundary="_0d1b52e6-8f2a-42c7-84a0-51a6d70fda2a_"

--_0d1b52e6-8f2a-42c7-84a0-51a6d70fda2a_
Content-Type: text/plain; charset="iso-2022-jp"
Content-Transfer-Encoding: 7bit


I had the same problems as well on ubuntu with kernel 2.6.38.8
> Date: Tue, 24 May 2011 23:55:18 +1200
> From: stewart@wic.co.nz
> To: linux-dvb@linuxtv.org
> Subject: Re: [linux-dvb] build.sh fails on kernel 2.6.38
> 
> On 23/05/11 22:09, Giwrgos Panou wrote:
> > Hello,
> > I tried to build the v4l-dvb on an ubuntu machine with kernel 2.6.38.8 generic
> > and I get make error:
> > =========================================
> > /home/z/media_build/v4l/kinect.c:38:19: error: ‘D_ERR’ undeclared here (not in a function)
> > /home/z/media_build/v4l/kinect.c:38:27: error: ‘D_PROBE’ undeclared here (not in a function)
> > /home/z/media_build/v4l/kinect.c:38:37: error: ‘D_CONF’ undeclared here (not in a function)
> > /home/z/media_build/v4l/kinect.c:38:46: error: ‘D_STREAM’ undeclared here (not in a function)
> > /home/z/media_build/v4l/kinect.c:38:57: error: ‘D_FRAM’ undeclared here (not in a function)
> > /home/z/media_build/v4l/kinect.c:38:66: error: ‘D_PACK’ undeclared here (not in a function)
> > /home/z/media_build/v4l/kinect.c:39:2: error: ‘D_USBI’ undeclared here (not in a function)
> > /home//media_build/v4l/kinect.c:39:11: error: ‘D_USBO’ undeclared here (not in a function)
> > /home//media_build/v4l/kinect.c:39:20: error: ‘D_V4L2′ undeclared here (not in a function)
> > make[3]: *** [/home//media_build/v4l/kinect.o] Error 1
> > make[2]: *** [_module_/home//media_build/v4l] Error 2
> > =================================================================
> I also see, compiling against 2.6.38:
>    CC [M]  /usr/src/v4l-dvb/v4l/flexcop-i2c.o
> /usr/src/v4l-dvb/v4l/flexcop-i2c.c: In function 'flexcop_i2c_init':
> /usr/src/v4l-dvb/v4l/flexcop-i2c.c:253:39: error: 'I2C_CLASS_TV_DIGITAL' 
> undeclared (first use in this function)
> https://patchwork.kernel.org/patch/250451/ refers
> 
>    CC [M]  /usr/src/v4l-dvb/v4l/bttv-i2c.o
> /usr/src/v4l-dvb/v4l/bttv-i2c.c: In function 'init_bttv_i2c_ir':
> /usr/src/v4l-dvb/v4l/bttv-i2c.c:437:3: error: too few arguments to 
> function 'i2c_new_probed_device'
> http://www.gossamer-threads.com/lists/linux/kernel/1282040 refers
> 
> and finally
>    CC [M]  /usr/src/v4l-dvb/v4l/dmxdev.o
> /usr/src/v4l-dvb/v4l/dmxdev.c: In function 'dvb_dmxdev_start_feed':
> /usr/src/v4l-dvb/v4l/dmxdev.c:583:13: warning: comparison between 'enum 
> dmx_ts_pes' and 'enum <anonymous>'
> /usr/src/v4l-dvb/v4l/dmxdev.c: At top level:
> /usr/src/v4l-dvb/v4l/dmxdev.c:1142:2: error: unknown field 'ioctl' 
> specified in initializer
> /usr/src/v4l-dvb/v4l/dmxdev.c:1142:2: warning: initialization from 
> incompatible pointer type
> /usr/src/v4l-dvb/v4l/dmxdev.c:1211:2: error: unknown field 'ioctl' 
> specified in initializer
> /usr/src/v4l-dvb/v4l/dmxdev.c:1211:2: warning: initialization from 
> incompatible pointer type
> which I cannot yet fix.
> 
> I note that the cx88 bug that affects HVR3000 and HVR4000 is still in 
> this build
> https://lists.launchpad.net/mythbuntu-bugs/msg03390.html
> 
> I would hugely appreciate the latter bug being fixed!!
> Regards,
> Stu
> 
> 
> 
> _______________________________________________
> linux-dvb users mailing list
> For V4L/DVB development, please use instead linux-media@vger.kernel.org
> linux-dvb@linuxtv.org
> http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
 		 	   		  
--_0d1b52e6-8f2a-42c7-84a0-51a6d70fda2a_
Content-Type: text/html; charset="iso-2022-jp"
Content-Transfer-Encoding: 7bit

<html>
<head>
<style><!--
.hmmessage P
{
margin:0px;
padding:0px
}
body.hmmessage
{
font-size: 10pt;
font-family:Tahoma
}
--></style>
</head>
<body class='hmmessage'>
I had the same problems as well&nbsp;on ubuntu with kernel 2.6.38.8<div><br>&gt; Date: Tue, 24 May 2011 23:55:18 +1200<br>&gt; From: stewart@wic.co.nz<br>&gt; To: linux-dvb@linuxtv.org<br>&gt; Subject: Re: [linux-dvb] build.sh fails on kernel 2.6.38<br>&gt; <br>&gt; On 23/05/11 22:09, Giwrgos Panou wrote:<br>&gt; &gt; Hello,<br>&gt; &gt; I tried to build the v4l-dvb on an ubuntu machine with kernel 2.6.38.8 generic<br>&gt; &gt; and I get make error:<br>&gt; &gt; =========================================<br>&gt; &gt; /home/z/media_build/v4l/kinect.c:38:19: error: ‘D_ERR’ undeclared here (not in a function)<br>&gt; &gt; /home/z/media_build/v4l/kinect.c:38:27: error: ‘D_PROBE’ undeclared here (not in a function)<br>&gt; &gt; /home/z/media_build/v4l/kinect.c:38:37: error: ‘D_CONF’ undeclared here (not in a function)<br>&gt; &gt; /home/z/media_build/v4l/kinect.c:38:46: error: ‘D_STREAM’ undeclared here (not in a function)<br>&gt; &gt; /home/z/media_build/v4l/kinect.c:38:57: error: ‘D_FRAM’ undeclared here (not in a function)<br>&gt; &gt; /home/z/media_build/v4l/kinect.c:38:66: error: ‘D_PACK’ undeclared here (not in a function)<br>&gt; &gt; /home/z/media_build/v4l/kinect.c:39:2: error: ‘D_USBI’ undeclared here (not in a function)<br>&gt; &gt; /home//media_build/v4l/kinect.c:39:11: error: ‘D_USBO’ undeclared here (not in a function)<br>&gt; &gt; /home//media_build/v4l/kinect.c:39:20: error: ‘D_V4L2′ undeclared here (not in a function)<br>&gt; &gt; make[3]: *** [/home//media_build/v4l/kinect.o] Error 1<br>&gt; &gt; make[2]: *** [_module_/home//media_build/v4l] Error 2<br>&gt; &gt; =================================================================<br>&gt; I also see, compiling against 2.6.38:<br>&gt;    CC [M]  /usr/src/v4l-dvb/v4l/flexcop-i2c.o<br>&gt; /usr/src/v4l-dvb/v4l/flexcop-i2c.c: In function 'flexcop_i2c_init':<br>&gt; /usr/src/v4l-dvb/v4l/flexcop-i2c.c:253:39: error: 'I2C_CLASS_TV_DIGITAL' <br>&gt; undeclared (first use in this function)<br>&gt; https://patchwork.kernel.org/patch/250451/ refers<br>&gt; <br>&gt;    CC [M]  /usr/src/v4l-dvb/v4l/bttv-i2c.o<br>&gt; /usr/src/v4l-dvb/v4l/bttv-i2c.c: In function 'init_bttv_i2c_ir':<br>&gt; /usr/src/v4l-dvb/v4l/bttv-i2c.c:437:3: error: too few arguments to <br>&gt; function 'i2c_new_probed_device'<br>&gt; http://www.gossamer-threads.com/lists/linux/kernel/1282040 refers<br>&gt; <br>&gt; and finally<br>&gt;    CC [M]  /usr/src/v4l-dvb/v4l/dmxdev.o<br>&gt; /usr/src/v4l-dvb/v4l/dmxdev.c: In function 'dvb_dmxdev_start_feed':<br>&gt; /usr/src/v4l-dvb/v4l/dmxdev.c:583:13: warning: comparison between 'enum <br>&gt; dmx_ts_pes' and 'enum &lt;anonymous&gt;'<br>&gt; /usr/src/v4l-dvb/v4l/dmxdev.c: At top level:<br>&gt; /usr/src/v4l-dvb/v4l/dmxdev.c:1142:2: error: unknown field 'ioctl' <br>&gt; specified in initializer<br>&gt; /usr/src/v4l-dvb/v4l/dmxdev.c:1142:2: warning: initialization from <br>&gt; incompatible pointer type<br>&gt; /usr/src/v4l-dvb/v4l/dmxdev.c:1211:2: error: unknown field 'ioctl' <br>&gt; specified in initializer<br>&gt; /usr/src/v4l-dvb/v4l/dmxdev.c:1211:2: warning: initialization from <br>&gt; incompatible pointer type<br>&gt; which I cannot yet fix.<br>&gt; <br>&gt; I note that the cx88 bug that affects HVR3000 and HVR4000 is still in <br>&gt; this build<br>&gt; https://lists.launchpad.net/mythbuntu-bugs/msg03390.html<br>&gt; <br>&gt; I would hugely appreciate the latter bug being fixed!!<br>&gt; Regards,<br>&gt; Stu<br>&gt; <br>&gt; <br>&gt; <br>&gt; _______________________________________________<br>&gt; linux-dvb users mailing list<br>&gt; For V4L/DVB development, please use instead linux-media@vger.kernel.org<br>&gt; linux-dvb@linuxtv.org<br>&gt; http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb<br></div> 		 	   		  </body>
</html>
--_0d1b52e6-8f2a-42c7-84a0-51a6d70fda2a_--


--===============0914161792==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
linux-dvb users mailing list
For V4L/DVB development, please use instead linux-media@vger.kernel.org
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
--===============0914161792==--
