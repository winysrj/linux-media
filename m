Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from smtp101.biz.mail.mud.yahoo.com ([68.142.200.236])
	by www.linuxtv.org with smtp (Exim 4.63)
	(envelope-from <xbzhang@telegentsystems.com>) id 1LXoex-0000AL-Ll
	for linux-dvb@linuxtv.org; Fri, 13 Feb 2009 04:24:12 +0100
Message-ID: <4994E795.6030700@telegentsystems.com>
Date: Fri, 13 Feb 2009 11:23:01 +0800
From: Zhang Xiaobing <xbzhang@telegentsystems.com>
MIME-Version: 1.0
To: linux-dvb@linuxtv.org
Subject: [linux-dvb] A dvb-core code problem
Reply-To: linux-media@vger.kernel.org
List-Unsubscribe: <http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb>,
	<mailto:linux-dvb-request@linuxtv.org?subject=unsubscribe>
List-Archive: <http://www.linuxtv.org/pipermail/linux-dvb>
List-Post: <mailto:linux-dvb@linuxtv.org>
List-Help: <mailto:linux-dvb-request@linuxtv.org?subject=help>
List-Subscribe: <http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb>,
	<mailto:linux-dvb-request@linuxtv.org?subject=subscribe>
Content-Type: multipart/mixed; boundary="===============1383362058=="
Mime-version: 1.0
Sender: linux-dvb-bounces@linuxtv.org
Errors-To: linux-dvb-bounces+mchehab=infradead.org@linuxtv.org
List-ID: <linux-dvb@linuxtv.org>

This is a multi-part message in MIME format.
--===============1383362058==
Content-Type: multipart/alternative;
 boundary="------------000502000301090107030101"

This is a multi-part message in MIME format.
--------------000502000301090107030101
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit

I found a code problem in dvb-core when I was debugging with my dvb driver.

The code in dvb_dvr_release() file dmxdev.c
/* TODO */
    dvbdev->users--;
    if(*dvbdev->users== -1* && dmxdev->exit==1) {
        fops_put(file->f_op);
        file->f_op = NULL;
        mutex_unlock(&dmxdev->mutex);

"dvbdev->users== -1" should be changed to "dvbdev->users== 1", otherwise 
driver may block forever in dvb_dmxdev_release() where a wakeup 
condition is "dvbdev->users== 1".

Here is the code in dvb_dmxdev_release().

if (dmxdev->dvr_dvbdev->users > 1) {
        wait_event(dmxdev->dvr_dvbdev->wait_queue,
                *dmxdev->dvr_dvbdev->users==1*);
}

I hope it is right to post this message here.

-- 

Xiaobing Zhang


--------------000502000301090107030101
Content-Type: text/html; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit

<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
<html>
<head>
</head>
<body bgcolor="#ffffff" text="#000000">
I found a code problem in dvb-core when I was debugging with my dvb
driver.<br>
<br>
The code in dvb_dvr_release() file dmxdev.c<br>
/* TODO */<br>
&nbsp;&nbsp;&nbsp; dvbdev-&gt;users--;<br>
&nbsp;&nbsp;&nbsp; if(<b>dvbdev-&gt;users== -1</b> &amp;&amp; dmxdev-&gt;exit==1) {<br>
&nbsp;&nbsp;&nbsp; &nbsp;&nbsp;&nbsp; fops_put(file-&gt;f_op);<br>
&nbsp;&nbsp;&nbsp; &nbsp;&nbsp;&nbsp; file-&gt;f_op = NULL;<br>
&nbsp;&nbsp;&nbsp; &nbsp;&nbsp;&nbsp; mutex_unlock(&amp;dmxdev-&gt;mutex);<br>
<br>
"dvbdev-&gt;users== -1" should be changed to "dvbdev-&gt;users== 1",
otherwise driver may block forever in dvb_dmxdev_release() where a
wakeup condition is "dvbdev-&gt;users== 1". <br>
<br>
Here is the code in dvb_dmxdev_release().<br>
<br>
if (dmxdev-&gt;dvr_dvbdev-&gt;users &gt; 1) {<br>
&nbsp;&nbsp;&nbsp; &nbsp;&nbsp;&nbsp; wait_event(dmxdev-&gt;dvr_dvbdev-&gt;wait_queue,<br>
&nbsp;&nbsp;&nbsp; &nbsp;&nbsp;&nbsp; &nbsp;&nbsp;&nbsp; &nbsp;&nbsp;&nbsp; <b>dmxdev-&gt;dvr_dvbdev-&gt;users==1</b>);<br>
}<br>
<br>
I hope it is right to post this message here.<br>
<br>
<div class="moz-signature">-- <br>
<meta http-equiv="CONTENT-TYPE" content="text/html; ">
<title></title>
<meta name="GENERATOR" content="OpenOffice.org 2.4  (Linux)">
<meta name="AUTHOR" content="zhang">
<meta name="CREATED" content="20081117;15071400">
<meta name="CHANGEDBY" content="zhang">
<meta name="CHANGED" content="20081119;15534200">
<meta name="CHANGEDBY" content="zhang">
<p style="margin-bottom: 0in; line-height: 0.1in;" align="justify"><font
 color="#365f91"><font size="2">Xiaobing </font></font><font
 color="#365f91"><font size="2">Zhang
</font></font></p>
</div>
</body>
</html>

--------------000502000301090107030101--


--===============1383362058==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
linux-dvb users mailing list
For V4L/DVB development, please use instead linux-media@vger.kernel.org
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
--===============1383362058==--
