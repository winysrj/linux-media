Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id mADJAipX026929
	for <video4linux-list@redhat.com>; Thu, 13 Nov 2008 14:10:44 -0500
Received: from smtp2-g19.free.fr (smtp2-g19.free.fr [212.27.42.28])
	by mx3.redhat.com (8.13.8/8.13.8) with ESMTP id mADJAVTk025183
	for <video4linux-list@redhat.com>; Thu, 13 Nov 2008 14:10:31 -0500
To: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
References: <1226521783-19806-1-git-send-email-robert.jarzmik@free.fr>
	<1226521783-19806-2-git-send-email-robert.jarzmik@free.fr>
	<1226521783-19806-3-git-send-email-robert.jarzmik@free.fr>
	<1226521783-19806-4-git-send-email-robert.jarzmik@free.fr>
	<1226521783-19806-5-git-send-email-robert.jarzmik@free.fr>
	<1226521783-19806-6-git-send-email-robert.jarzmik@free.fr>
	<1226521783-19806-7-git-send-email-robert.jarzmik@free.fr>
	<1226521783-19806-8-git-send-email-robert.jarzmik@free.fr>
	<1226521783-19806-9-git-send-email-robert.jarzmik@free.fr>
	<1226521783-19806-10-git-send-email-robert.jarzmik@free.fr>
	<Pine.LNX.4.64.0811122216520.9188@axis700.grange>
From: Robert Jarzmik <robert.jarzmik@free.fr>
Date: Thu, 13 Nov 2008 20:10:29 +0100
In-Reply-To: <Pine.LNX.4.64.0811122216520.9188@axis700.grange> (Guennadi
	Liakhovetski's message of "Wed\,
	12 Nov 2008 22\:19\:40 +0100 \(CET\)")
Message-ID: <878wrnv3ve.fsf@free.fr>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: video4linux-list@redhat.com
Subject: Re: [PATCH 09/13] pxa_camera: use the translation framework
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

Guennadi Liakhovetski <g.liakhovetski@gmx.de> writes:

> Do I understand it right, that with this all Bayer and monochrome formats 
> will stop working with pxa? If so - not good. Remember what we discussed 
> about a default "pass-through" case?
Oh yes, right. I'm an ass. To be more precise, a git ass.
I added the missing patch 13/13 ... sorry. This was the one which provided the
"pass-through".

--
Robert

--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
