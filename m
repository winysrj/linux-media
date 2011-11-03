Return-path: <linux-media-owner@vger.kernel.org>
Received: from mr.siano-ms.com ([62.0.79.70]:40557 "EHLO
	Siano-NV.ser.netvision.net.il" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1755638Ab1KCL5x convert rfc822-to-8bit
	(ORCPT <rfc822;linux-media@vger.kernel.org>);
	Thu, 3 Nov 2011 07:57:53 -0400
Content-class: urn:content-classes:message
MIME-Version: 1.0
Content-Type: text/plain;
	charset="US-ASCII"
Content-Transfer-Encoding: 8BIT
Subject: Problem with DVB module during suspend/hibernate.
Date: Thu, 3 Nov 2011 14:00:51 +0200
Message-ID: <D945C405928A9949A0F33C69E64A1A3BD8D5EF@s-mail.siano-ms.ent>
From: "Doron Cohen" <doronc@siano-ms.com>
To: <linux-media@vger.kernel.org>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi,
I am dealing with a problems with suspend/hibernate freeze during resume
when DVB API is used. I found a workaround for it here
<http://forum.xbmc.org/showthread.php?t=71490> which solve the problem
but this is not a solution only a workaround.

Problem is that when using USB DVB tuner the tuner is turned off/on
during the suspend process, meaning that during the resume the USB
disconnect and probe methods are running.
The disconnect method is causing a call to dvb_unregister_frontend (or,
if changing the order to dvb_dmxdev_release) This call hangs on
wait_event until fepriv->dvbdev->users will free all users. 

This works fine when application is not playing the video, but if an
application receives TV (tested with VLC and Kaffeine but true to all)
Users will be free only when the application stops. It works if the
device is plugged out during video display (users will be released when
application closes the frontend and than the device will be free) but
during the resume process, user interface is not working and there is a
dead lock system must be hard power off and on.

The workaround just causes the application to close force before the
suspend.

Since I only have Siano devices at hand, I couldn't prove if the problem
is with our driver or in all USB receivers or only related to Siano
driver, but exploring the code it seems that everybody are working in
the same way.

Can anyone approve that suspend and hibernate works fine when DVB is
being watched by an application?

Thanks,
Doron

