Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx1.redhat.com (mx1.redhat.com [172.16.48.31])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id n77A3Mol031473
	for <video4linux-list@redhat.com>; Fri, 7 Aug 2009 06:03:22 -0400
Received: from mail-ew0-f208.google.com (mail-ew0-f208.google.com
	[209.85.219.208])
	by mx1.redhat.com (8.13.8/8.13.8) with ESMTP id n77A3551022787
	for <video4linux-list@redhat.com>; Fri, 7 Aug 2009 06:03:06 -0400
Received: by ewy4 with SMTP id 4so317531ewy.3
	for <video4linux-list@redhat.com>; Fri, 07 Aug 2009 03:03:05 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <eedb5540908070134i3e94cddbv358ab6190b482715@mail.gmail.com>
References: <eedb5540908070134i3e94cddbv358ab6190b482715@mail.gmail.com>
Date: Fri, 7 Aug 2009 12:03:05 +0200
Message-ID: <eedb5540908070303t325d8573o9b8b85301238ecd5@mail.gmail.com>
From: javier Martin <javier.martin@vista-silicon.com>
To: linux-arm-kernel@lists.arm.linux.org.uk
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Cc: Russell King <linux@arm.linux.org.uk>, video4linux-list@redhat.com
Subject: Re: [PATCH] MX2x: Add CSI platform device and resources.
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

This patch was sent mainly to initiate a discussion on how to consider
data acquisition device in i.MX2x platforms.

AFAIK, in both i.MX21 and i.MX27 there is a CSI HW module and a PrP HW
module. While they can be used on its own, with a direct communication
to the AHB bus, we could think of separating both modules in two
different devices, the patch I sent before would apply in this case
for CSI.

However, we could also think of both HW devices as a video acquisition
chain, because it doesn't makes sense in V4L2 model using the PrP
module on its own. Thus a "capture" device which enclosed both CSI and
PrP would make more sense.

What do you think?

-- 
Javier Martin
Vista Silicon S.L.
Universidad de Cantabria
CDTUC - FASE C - Oficina S-345
Avda de los Castros s/n
39005- Santander. Cantabria. Spain
+34 942 25 32 60
www.vista-silicon.com

--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
