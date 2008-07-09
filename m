Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id m69M9256016696
	for <video4linux-list@redhat.com>; Wed, 9 Jul 2008 18:09:02 -0400
Received: from smtp2.versatel.nl (smtp2.versatel.nl [62.58.50.89])
	by mx3.redhat.com (8.13.8/8.13.8) with ESMTP id m69M7r5e022605
	for <video4linux-list@redhat.com>; Wed, 9 Jul 2008 18:07:54 -0400
Message-ID: <48752A4D.7050800@hhs.nl>
Date: Wed, 09 Jul 2008 23:14:53 +0200
From: Hans de Goede <j.w.r.degoede@hhs.nl>
MIME-Version: 1.0
To: Jean-Francois Moine <moinejf@free.fr>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Cc: video4linux-list@redhat.com
Subject: PATCH: gspca-sn9c102-sensor-gain.patch
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

Currently the sn9c102 gain control, only controls the digital gain in the
sn9c102, but most sensors have an analog gain in the sensor, allowing for a
much wider sensitivity range.

This patch adds support for the sensor gain for the tas5110 and ov6650 sensors.
Note that both gains are controlled with a single v4l2 ctrl, as they are both
gain. The ctrl now hs a range of 0-511, raising it one step at a time, will
first raise the sensor gain 1 one its 0-255 scale and then the next step will
raise the bridge gain on its 0-255 scale. Note that the bridge really has a
0-15 scale, so it only gets raised once every 32 steps
(of the full 0-511 scale).

This patch combined with the configurable exposure and autoexposure patch,
makes my 2 sn9c102 cams work well in a wide variety of lighting conditions.

Signed-off-by: Hans de Goede <j.w.r.degoede@hhs.nl>

Regards,

Hans

--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
