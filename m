Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx1.redhat.com (ext-mx09.extmail.prod.ext.phx2.redhat.com
	[10.5.110.13])
	by int-mx03.intmail.prod.int.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id o0C9rP7s005991
	for <video4linux-list@redhat.com>; Tue, 12 Jan 2010 04:53:25 -0500
Received: from mail-pz0-f184.google.com (mail-pz0-f184.google.com
	[209.85.222.184])
	by mx1.redhat.com (8.13.8/8.13.8) with ESMTP id o0C9r7He007280
	for <video4linux-list@redhat.com>; Tue, 12 Jan 2010 04:53:09 -0500
Received: by pzk14 with SMTP id 14so2446020pzk.23
	for <video4linux-list@redhat.com>; Tue, 12 Jan 2010 01:53:06 -0800 (PST)
MIME-Version: 1.0
Date: Tue, 12 Jan 2010 10:53:06 +0100
Message-ID: <fe6fd5f61001120153v5604e61qd2900909b808be99@mail.gmail.com>
Subject: problem with the register of driver that works with
	soc_camera_subsystem
From: Carlos Lavin <carlos.lavin@vista-silicon.com>
To: video4linux-list <video4linux-list@redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/video4linux-list>,
	<mailto:video4linux-list-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/mailman/private/video4linux-list>
List-Post: <mailto:video4linux-list@redhat.com>
List-Help: <mailto:video4linux-list-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/video4linux-list>,
	<mailto:video4linux-list-request@redhat.com?subject=subscribe>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Sender: video4linux-list-bounces@redhat.com
Errors-To: video4linux-list-bounces@redhat.com
List-ID: <video4linux-list@redhat.com>

I am trying build a system on video with mx27 and ov7670 sensor but when I
want register my driver that works with soc_camera subsystem in the 2.6.30
version(I have works in this version because my boss wants it that way ), I
executed the function "soc_camera_host_register(&mx27_soc_camera_host);" In
the probe function of host-camera, this funcion is in the soc_camera.c and
this function call to "scan_add_host" and this funcion is:
1- static void scan_add_host(struct soc_camera_host *ici)
2- {
3-    struct soc_camera_device *icd;
4-    mutex_lock(&list_lock);
5-    list_for_each_entry(icd, &devices, list) {
6-        if (icd->iface == ici->nr) {
7-            icd->dev.parent = &ici->dev;
8-            device_register_link(icd);
9-        }
10-    }
11-   mutex_unlock(&list_lock);
12-}

Well, in the probe function of camera-host I put ici->nr=0 (ici is
soc_camera_host); but icd-> iface I don't know where is declared, in my chip
camera I declare a soc_camera_device where I put the iface=0, but in this
function, "scan_add_host" in the if of line 6, the icd-iface is different of
0, and the function device_register_link isn't executed.

In the chip_camera this function,"device_register_link"(is called for your
appropriate function,scan_add_device) yes is executed, anybody know anything
about this problem? is a problem or this function only is necessary to
execute one once for both(chip-camera and host-camera), I think that is
necessary that this function is executed for both but I am rookie in this
topics. anybody help me?
Thanks for your time.
--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
