Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx1.redhat.com (ext-mx02.extmail.prod.ext.phx2.redhat.com
	[10.5.110.6])
	by int-mx08.intmail.prod.int.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id nA28cnTv022406
	for <video4linux-list@redhat.com>; Mon, 2 Nov 2009 03:38:49 -0500
Received: from eu1sys200aog104.obsmtp.com (eu1sys200aog104.obsmtp.com
	[207.126.144.117])
	by mx1.redhat.com (8.13.8/8.13.8) with ESMTP id nA28cXsD019092
	for <video4linux-list@redhat.com>; Mon, 2 Nov 2009 03:38:34 -0500
Received: from zeta.dmz-us.st.com (ns4.st.com [167.4.80.115])
	by beta.dmz-us.st.com (STMicroelectronics) with ESMTP id 4C1CA65
	for <video4linux-list@redhat.com>; Mon,  2 Nov 2009 08:35:51 +0000 (GMT)
Received: from mail1.agr.st.com (mail1.agr.st.com [164.130.4.71])
	by zeta.dmz-us.st.com (STMicroelectronics) with ESMTP id 74C44B6
	for <video4linux-list@redhat.com>; Mon,  2 Nov 2009 08:38:30 +0000 (GMT)
Message-ID: <4AEE9AAA.80104@st.com>
Date: Mon, 02 Nov 2009 09:39:06 +0100
From: Raffaele BELARDI <raffaele.belardi@st.com>
MIME-Version: 1.0
To: v4l <video4linux-list@redhat.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Subject: hvr1300 DVB regression
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

I'm no longer able with recent kernels to tune DVB channels with my
HVR1300. This is a mythtv box but I replicated the problem using
www.linuxtv.org utilities to exclude mythtv issues.

Using kernel 2.6.26-r4 and 2.6.27-r8 I am able to tune both analog and
DVB channels.
Using kernel 2.6.30-r6 I can only tune to analog channels. 'dvbscan'
returns no channel info.

I suspect a tuner problem.

With 2.6.27 'grep tuner syslog' reports:

cx88[0]: TV tuner type 63, Radio tuner type -1
tuner' 2-0061: chip found @ 0xc2 (cx88[0])
tuner' 2-0063: chip found @ 0xc6 (cx88[0])
tveeprom 2-0050: tuner model is Philips FMD1216MEX (idx 133, type 63)
tuner-simple 2-0061: creating new instance
tuner-simple 2-0061: type set to 63 (Philips FMD1216ME MK3 Hybrid Tuner)
tuner-simple 2-0061: attaching existing instance
tuner-simple 2-0061: type set to 63 (Philips FMD1216ME MK3 Hybrid Tuner)

With kernel 2.6.30:

cx88[0]: TV tuner type 63, Radio tuner type -1
cx88[0]: i2c init: enabling analog demod on HVR1300/3000/4000 tuner
tuner 2-0043: chip found @ 0x86 (cx88[0])
tuner 2-0061: chip found @ 0xc2 (cx88[0])
tveeprom 2-0050: tuner model is Philips FMD1216MEX (idx 133, type 78)
tuner-simple 2-0061: creating new instance
tuner-simple 2-0061: type set to 78 (Philips FMD1216MEX MK3 Hybrid Tuner)
tuner-simple 2-0061: attaching existing instance
tuner-simple 2-0061: couldn't set type to 63. Using 78 (Philips
FMD1216MEX MK3 Hybrid Tuner) instead

Same kernel, another boot:
tveeprom 2-0050: Encountered bad packet header [07]. Corrupt or not a
Hauppauge eeprom.
cx88[0]: TV tuner type 63, Radio tuner type -1
cx88[0]: i2c init: enabling analog demod on HVR1300/3000/4000 tuner
tuner 2-0043: chip found @ 0x86 (cx88[0])
tuner 2-0061: chip found @ 0xc2 (cx88[0])
tuner 2-0061: tuner type not set
tuner-simple 2-0061: creating new instance
tuner-simple 2-0061: type set to 63 (Philips FMD1216ME MK3 Hybrid Tuner)
tuner 2-0061: tuner type not set
tuner 2-0061: tuner type not set

Once the FMD1216ME tuner is detected as 63, the other as 78.

I can test other kernels between .27 and .30 to restrict the problem
area if necessary.

Any other suggestion?

thanks,

raffaele

--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
