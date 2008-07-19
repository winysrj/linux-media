Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id m6J87bw7013794
	for <video4linux-list@redhat.com>; Sat, 19 Jul 2008 04:07:37 -0400
Received: from smtp3-g19.free.fr (smtp3-g19.free.fr [212.27.42.29])
	by mx3.redhat.com (8.13.8/8.13.8) with ESMTP id m6J87PUC010163
	for <video4linux-list@redhat.com>; Sat, 19 Jul 2008 04:07:25 -0400
Message-ID: <4881A0E9.70607@free.fr>
Date: Sat, 19 Jul 2008 10:08:09 +0200
From: Thierry Merle <thierry.merle@free.fr>
MIME-Version: 1.0
To: Linux and Kernel Video <video4linux-list@redhat.com>,
	Jean-Francois Moine <moinejf@free.fr>, Hans de Goede <j.w.r.degoede@hhs.nl>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Cc: 
Subject: [RFC] webcam sensor module
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

Hello all,
While analyzing the w9968cf v4l1 module, I saw that my webcam commands a OV7620 sensor. This sensor has a specific module: ovcamchip (v4l1).
My webcam is a Creative Webcam Go Plus.

In gspca, the zc3xx driver addresses the same sensor, but in only one module containing USB bridge controls and sensor controls.

My question is: why gspca does not use the same infrastructure? I mean 1 module for the USB bridge (like w9968cf) and 1 module for the sensor (like ovcamchip).
My first thought was to re-write w9968cf in the gspca frame but I wanted to keep this modular way of life.

>From a high-level point of view it is similar to analog TV tuners: we have a modular separation between USB bridges (like usbvision) and video decoders (like saa7115).

During my vacation I will analyse a bit further if the gspca infrastructure can be improved to integrate the modular sensor model since it can save some code.

The final aim is to make the w9968cf compatible with the v4l2 decompression library (v4l2-apps/lib/libv4l) that requires that the driver shall be v4l2 compliant.

Cheers,
Thierry

--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
