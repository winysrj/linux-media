Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id m577DaY0022196
	for <video4linux-list@redhat.com>; Sat, 7 Jun 2008 03:13:36 -0400
Received: from mail.gmx.net (mail.gmx.net [213.165.64.20])
	by mx3.redhat.com (8.13.8/8.13.8) with SMTP id m577D8EL006544
	for <video4linux-list@redhat.com>; Sat, 7 Jun 2008 03:13:16 -0400
Message-ID: <484A34DF.2030208@gmx.net>
Date: Sat, 07 Jun 2008 09:12:31 +0200
From: r006 <rolf.sader@gmx.net>
MIME-Version: 1.0
To: video4linux-list@redhat.com
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 8bit
Subject: Re: Hauppauge HVR-1300 analog troubles
List-Unsubscribe: <https://www.redhat.com/mailman/listinfo/video4linux-list>,
	<mailto:video4linux-list-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/mailman/private/video4linux-list>
List-Post: <mailto:video4linux-list@redhat.com>
List-Help: <mailto:video4linux-list-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/video4linux-list>,
	<mailto:video4linux-list-request@redhat.com?subject=subscribe>
Sender: video4linux-list-bounces@redhat.com
Errors-To: video4linux-list-bounces@redhat.com
List-ID: <video4linux-list@redhat.com>

Subject: Re: Hauppauge HVR-1300 analog troubles

Date: Saturday 07 June 2008

From: rolf.sader@gmx.net

To: video4linux-list@redhat.com

On Sunday 01 June 2008 14:37:23 Jonatan Åkerlind wrote:

> An update:

>

> I booted the system up today and modprobed tuner with debug=1 and cx88xx

> with audio_debug=1 ir_debug=1 and tried to scan for channels and this

> time everything worked just fine. Tried unloading the modules and

> reloading everything without debugging and it still works. I cannot

> really tell what is different this time from all my other attempts at

> this but anyway it seems to be working.

>

> Now, is there any possibility to get the mpeg2-encoder working? I'm

> using the cx88-blackbird module but i'm not really sure if or what

> firmware I should be downloading to the card.

>

> /Jonatan

>

> --


look at http://ivtvdriver.org/index.php/Firmware

The firmware you need is (v4l-cx2341x-enc.fw). You can get it here:

http://dl.ivtvdriver.org/ivtv/firmware/firmware.tar.gz


regards

Rolf

-------------------------------------------------------

--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
