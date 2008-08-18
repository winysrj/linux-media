Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from fg-out-1718.google.com ([72.14.220.157])
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <jaymode@gmail.com>) id 1KVDvJ-0006w1-CL
	for linux-dvb@linuxtv.org; Tue, 19 Aug 2008 01:14:07 +0200
Received: by fg-out-1718.google.com with SMTP id e21so1626488fga.25
	for <linux-dvb@linuxtv.org>; Mon, 18 Aug 2008 16:14:01 -0700 (PDT)
Message-ID: <6664ae760808181614g47d65c7atf71d564d815934a8@mail.gmail.com>
Date: Mon, 18 Aug 2008 19:14:01 -0400
From: "Jay Modi" <jaymode@gmail.com>
To: linux-dvb@linuxtv.org
MIME-Version: 1.0
Subject: [linux-dvb] Hauppauge HVR-1800 Analog issues
List-Unsubscribe: <http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb>,
	<mailto:linux-dvb-request@linuxtv.org?subject=unsubscribe>
List-Archive: <http://www.linuxtv.org/pipermail/linux-dvb>
List-Post: <mailto:linux-dvb@linuxtv.org>
List-Help: <mailto:linux-dvb-request@linuxtv.org?subject=help>
List-Subscribe: <http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb>,
	<mailto:linux-dvb-request@linuxtv.org?subject=subscribe>
Content-Type: multipart/mixed; boundary="===============0332574951=="
Mime-version: 1.0
Sender: linux-dvb-bounces@linuxtv.org
Errors-To: linux-dvb-bounces+mchehab=infradead.org@linuxtv.org
List-ID: <linux-dvb@linuxtv.org>

--===============0332574951==
Content-Type: multipart/alternative;
	boundary="----=_Part_96978_11864544.1219101241864"

------=_Part_96978_11864544.1219101241864
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

I have just upgraded to the Ubuntu development branch to see if I can get
the Hauppauge HVR 1800 Analog working. I have extracted the firmware and
placed it in the /lib/firmware/<kernel-vers> directory. I can view video
with tvtime but I do not get any audio, but this is true on my other tuners.
I then tried to use mythtv and was successful at getting both audio and
video a few times. After that I did not have any luck. I tried shutting down
and then bringing the system back up but that did not help. I have attached
some relevant error messages.

Output from dmesg:
[  248.423820] Firmware and/or mailbox pointer not initialized or corrupted,
signature = 0xffffffff, cmd = STOP_CAPTURE
[  249.594310] Firmware and/or mailbox pointer not initialized or corrupted,
signature = 0xffffffff, cmd = PING_FW
[  249.594370] firmware: requesting v4l-cx23885-enc.fw
[  279.676376] __ratelimit: 3 messages suppressed
[  279.676384] mythbackend[6502]: segfault at 144 ip b7cc699d sp ac0f4f40
error 4 in libmythtv-0.22.so.0.22.0[b7462000+a87000]


Output from mythbackend:
2008-08-18 18:44:29.335 TVRec(1): Changing from None to WatchingLiveTV
2008-08-18 18:44:29.340 TVRec(1): HW Tuner: 1->1
2008-08-18 18:44:30.690 Channel(/dev/video2) Error:
InitPictureAttribute(brightness): failed to query controls.
            eno: Invalid argument (22)
2008-08-18 18:44:31.781 Channel(/dev/video2) Error:
InitPictureAttribute(brightness): failed to query controls.
            eno: Invalid argument (22)
2008-08-18 18:44:31.781

Not ivtv or pvrusb2 or hdpvr driver


2008-08-18 18:44:31.783 MPEGRec(/dev/video2) Warning: Unable to get
recording volume parameters(max/min)
            eno: Invalid argument (22)
            using default range [0,65535].
2008-08-18 18:44:31.792 AutoExpire: CalcParams(): Max required Free Space:
2.0 GB w/freq: 15 min
2008-08-18 18:44:33.021 DevRdB(/dev/video2) Error: Problem reading fd(34)
            eno: Input/output error (5)
2008-08-18 18:44:33.022 DevRdB(/dev/video2) Error: Problem reading fd(34)
            eno: Input/output error (5)
2008-08-18 18:44:33.023 DevRdB(/dev/video2) Error: Problem reading fd(34)
            eno: Input/output error (5)
2008-08-18 18:44:33.023 DevRdB(/dev/video2) Error: Problem reading fd(34)
            eno: Input/output error (5)
2008-08-18 18:44:33.024 DevRdB(/dev/video2) Error: Problem reading fd(34)
            eno: Input/output error (5)
2008-08-18 18:44:33.024 DevRdB(/dev/video2) Error: Problem reading fd(34)
            eno: Input/output error (5)
2008-08-18 18:44:33.027 MPEGRec(/dev/video2) Error: Device error detected
2008-08-18 18:44:33.027 DevRdB(/dev/video2) Error: Stop(): Not running.
2008-08-18 18:44:33.027 MPEGRec(/dev/video2) Error: StopEncoding
            eno: Invalid argument (22)

After that the video is messed up from tvtime. I am currently using kernel
2.6.26-5-generic so I believe it should have some of the latest code for
this card. Is this a known issue or are there any suggestions?

------=_Part_96978_11864544.1219101241864
Content-Type: text/html; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

<div dir="ltr">I have just upgraded to the Ubuntu development branch to see if I can get the Hauppauge HVR 1800 Analog working. I have extracted the firmware and placed it in the /lib/firmware/&lt;kernel-vers&gt; directory. I can view video with tvtime but I do not get any audio, but this is true on my other tuners. I then tried to use mythtv and was successful at getting both audio and video a few times. After that I did not have any luck. I tried shutting down and then bringing the system back up but that did not help. I have attached some relevant error messages.<br>


<br>Output from dmesg:<br>[&nbsp; 248.423820] Firmware and/or mailbox pointer not initialized or corrupted, signature = 0xffffffff, cmd = STOP_CAPTURE<br>[&nbsp; 249.594310] Firmware and/or mailbox pointer not initialized or corrupted, signature = 0xffffffff, cmd = PING_FW<br>


[&nbsp; 249.594370] firmware: requesting v4l-cx23885-enc.fw<br>[&nbsp; 279.676376] __ratelimit: 3 messages suppressed<br>[&nbsp; 279.676384] mythbackend[6502]: segfault at 144 ip b7cc699d sp ac0f4f40 error 4 in libmythtv-0.22.so.0.22.0[b7462000+a87000]<br>


<br><br>Output from mythbackend:<br>2008-08-18 18:44:29.335 TVRec(1): Changing from None to WatchingLiveTV<br>2008-08-18 18:44:29.340 TVRec(1): HW Tuner: 1-&gt;1<br>2008-08-18 18:44:30.690 Channel(/dev/video2) Error: InitPictureAttribute(brightness): failed to query controls.<br>

&nbsp;&nbsp;&nbsp; &nbsp;&nbsp;&nbsp; &nbsp;&nbsp;&nbsp; eno: Invalid argument (22)<br>2008-08-18 18:44:31.781 Channel(/dev/video2) Error: InitPictureAttribute(brightness): failed to query controls.<br>&nbsp;&nbsp;&nbsp; &nbsp;&nbsp;&nbsp; &nbsp;&nbsp;&nbsp; eno: Invalid argument (22)<br>2008-08-18 18:44:31.781 <br>

<br>Not ivtv or pvrusb2 or hdpvr driver<br><br><br>2008-08-18 18:44:31.783 MPEGRec(/dev/video2) Warning: Unable to get recording volume parameters(max/min)<br>&nbsp;&nbsp;&nbsp; &nbsp;&nbsp;&nbsp; &nbsp;&nbsp;&nbsp; eno: Invalid argument (22)<br>&nbsp;&nbsp;&nbsp; &nbsp;&nbsp;&nbsp; &nbsp;&nbsp;&nbsp; using default range [0,65535].<br>

2008-08-18 18:44:31.792 AutoExpire: CalcParams(): Max required Free Space: 2.0 GB w/freq: 15 min<br>2008-08-18 18:44:33.021 DevRdB(/dev/video2) Error: Problem reading fd(34)<br>&nbsp;&nbsp;&nbsp; &nbsp;&nbsp;&nbsp; &nbsp;&nbsp;&nbsp; eno: Input/output error (5)<br>
2008-08-18 18:44:33.022 DevRdB(/dev/video2) Error: Problem reading fd(34)<br>
&nbsp;&nbsp;&nbsp; &nbsp;&nbsp;&nbsp; &nbsp;&nbsp;&nbsp; eno: Input/output error (5)<br>2008-08-18 18:44:33.023 DevRdB(/dev/video2) Error: Problem reading fd(34)<br>&nbsp;&nbsp;&nbsp; &nbsp;&nbsp;&nbsp; &nbsp;&nbsp;&nbsp; eno: Input/output error (5)<br>2008-08-18 18:44:33.023 DevRdB(/dev/video2) Error: Problem reading fd(34)<br>

&nbsp;&nbsp;&nbsp; &nbsp;&nbsp;&nbsp; &nbsp;&nbsp;&nbsp; eno: Input/output error (5)<br>2008-08-18 18:44:33.024 DevRdB(/dev/video2) Error: Problem reading fd(34)<br>&nbsp;&nbsp;&nbsp; &nbsp;&nbsp;&nbsp; &nbsp;&nbsp;&nbsp; eno: Input/output error (5)<br>2008-08-18 18:44:33.024 DevRdB(/dev/video2) Error: Problem reading fd(34)<br>

&nbsp;&nbsp;&nbsp; &nbsp;&nbsp;&nbsp; &nbsp;&nbsp;&nbsp; eno: Input/output error (5)<br>2008-08-18 18:44:33.027 MPEGRec(/dev/video2) Error: Device error detected<br>2008-08-18 18:44:33.027 DevRdB(/dev/video2) Error: Stop(): Not running.<br>2008-08-18 18:44:33.027 MPEGRec(/dev/video2) Error: StopEncoding<br>

&nbsp;&nbsp;&nbsp; &nbsp;&nbsp;&nbsp; &nbsp;&nbsp;&nbsp; eno: Invalid argument (22)<br><br>After that the video is messed up from tvtime. I am currently using kernel 2.6.26-5-generic so I believe it should have some of the latest code for this card. Is this a known issue or are there any suggestions?<br>

</div>

------=_Part_96978_11864544.1219101241864--


--===============0332574951==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
--===============0332574951==--
