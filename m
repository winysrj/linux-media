Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx1.redhat.com (ext-mx04.extmail.prod.ext.phx2.redhat.com
	[10.5.110.8])
	by int-mx03.intmail.prod.int.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id n9JNuVYW019578
	for <video4linux-list@redhat.com>; Mon, 19 Oct 2009 19:56:32 -0400
Received: from mail.gmx.net (mail.gmx.net [213.165.64.20])
	by mx1.redhat.com (8.13.8/8.13.8) with SMTP id n9JNuFhV014887
	for <video4linux-list@redhat.com>; Mon, 19 Oct 2009 19:56:16 -0400
Content-Type: text/plain; charset="iso-8859-1"
Date: Tue, 20 Oct 2009 01:56:13 +0200
From: "Oleksandr Naumenko" <o.naumenko@gmx.de>
Message-ID: <20091019235613.7680@gmx.net>
MIME-Version: 1.0
To: video4linux-list@redhat.com
Content-Transfer-Encoding: 8bit
Subject: AverTV GO 007 FM Plus
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

Hello,

I recently installed Linux and am currently trying to make my tv tunner (AverTV GO 007 FM Plus) work. Had real problems with autodetection so i just did as discribed on
http://www.ubuntuhcl.org/browse/product+AVerMedia_AVerTV_GO_007_FM_Plus_M15C?id=804

but i still don't have sound even tho i can see video now.

If i use "cat /dev/dsp1 | aplay -r 32000" I can hear sound, but its like compressed and totaly not understandable.

I tried to do as postet in 
http://www.archivum.info/video4linux-list@redhat.com/2005-03/00107/Re:_Philips_SILICON_tuner_starts_working_-_was_-_Re:_asus_tvfm-7135

but if i try to apply the patch, i'm asked which file i want to patch...
the problem is i have no clue which one it should be. Maybe someone could give me a small (a big one is very welcome as well) hint which file it is or what to do.
-- 
GRATIS für alle GMX-Mitglieder: Die maxdome Movie-FLAT!
Jetzt freischalten unter http://portal.gmx.net/de/go/maxdome01

--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
