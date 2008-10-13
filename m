Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id m9DDtgQY003351
	for <video4linux-list@redhat.com>; Mon, 13 Oct 2008 09:55:42 -0400
Received: from aa002msb.fastweb.it (aa002msb.fastweb.it [85.18.95.81])
	by mx3.redhat.com (8.13.8/8.13.8) with ESMTP id m9DDtNHU014209
	for <video4linux-list@redhat.com>; Mon, 13 Oct 2008 09:55:26 -0400
Received: from ess-server.Ess.local (37.253.89.168) by aa002msb.fastweb.it
	(8.0.013.8) id 48E3500E020F2ED8 for video4linux-list@redhat.com;
	Mon, 13 Oct 2008 15:55:23 +0200
Content-Disposition: inline
From: Daniele Paganelli <d.paganelli@expertsystemsolutions.it>
To: video4linux-list@redhat.com
Date: Mon, 13 Oct 2008 15:55:14 +0200
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Message-Id: <200810131555.14721.d.paganelli@expertsystemsolutions.it>
Content-Transfer-Encoding: 8bit
Subject: Fwd: [Linux-uvc-devel] inconsistency with video4linux2 MENU control
	type
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

Hi,
	I forward also to this list the message I sent to linux-uvc.
Maybe there is a deep video4linux2 meaning to this strange response I got from 
uvcvideo driver with logitech webcams.


Regards,
--
Daniele Paganelli
 Researcher
 Expert System Solutions S.r.l.
 Via Virgilio 58/L - 41100 Modena (ITALY)
 Tel: +39 0598860020 - Fax: +39 0598860024
 Email: d.paganelli@expertsystemsolutions.it
 Web: www.expertsystemsolutions.it



----------  Messaggio inoltrato  ----------

Oggetto: [Linux-uvc-devel] inconsistency with video4linux2 MENU control type
Data: venerdì 10 ottobre 2008
Da: Daniele Paganelli <d.paganelli@expertsystemsolutions.it>
A: linux-uvc-devel@lists.berlios.de

Dear UVC developers,
	I'm trying to program UVC devices using the video4linux2 API. 
I have problems understanding the output UVC driver give for a 
VIDIOC_QUERYCTRL ioctl.

Response struct (v4l2_queryctrl):
id: V4L2_CID_EXPOSURE
type: V4L2_CTRL_TYPE_MENU
name: 'Exposure, Auto' 
minimum: 0
maximum: 0
step: 9
default_value: 8
flags: 0 

The video4linux2 api specification states that, for a Menu type, the meaning 
of the queryctrl response given by the driver should be:

min: 0
step: 1
max: N-1

where N is the number of menu choices.

So how should I interpret the UVC response min=0/max=0/step=9???

I got this response for Logitech QuickCam Pro for Notebooks
and 
Logitech QuickCam Deluxe for Notebooks

Best regards
and thanks for the great driver ;)




_______________________________________________
Linux-uvc-devel mailing list
Linux-uvc-devel@lists.berlios.de
https://lists.berlios.de/mailman/listinfo/linux-uvc-devel




-------------------------------------------------------

--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
