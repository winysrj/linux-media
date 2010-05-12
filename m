Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx1.redhat.com (ext-mx03.extmail.prod.ext.phx2.redhat.com
	[10.5.110.7])
	by int-mx02.intmail.prod.int.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id o4C2UNmH020893
	for <video4linux-list@redhat.com>; Tue, 11 May 2010 22:30:24 -0400
Received: from twhqfe02.corpnet.xgitech.com (smtp2.xgitech.com [61.66.19.134])
	by mx1.redhat.com (8.13.8/8.13.8) with ESMTP id o4C2UBW6018343
	for <video4linux-list@redhat.com>; Tue, 11 May 2010 22:30:12 -0400
Content-class: urn:content-classes:message
MIME-Version: 1.0
Subject: RE: RGB format
Date: Wed, 12 May 2010 10:27:25 +0800
Message-ID: <7BDE3DB56E0B0144A1265CABF7785E6393FA75@MAIL03.corpnet.xgitech.com>
In-Reply-To: <AANLkTilJzGA8V6R1nSzViJXmHlgG1wRlT_brGX1BbpO_@mail.gmail.com>
References: <AANLkTimPNHc9fRnW_MI7Tmaq78oYoMVW_7vBgdU4T9Um@mail.gmail.com>
	<AANLkTilJzGA8V6R1nSzViJXmHlgG1wRlT_brGX1BbpO_@mail.gmail.com>
From: "Yi-Lin Shieh" <yilin_shieh@xgitech.com>
Cc: "video4linux-list" <video4linux-list@redhat.com>
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

Hi Carlos,

You can fill digit '0' to RGB565's lower bit to become RGB 888.

R4R3R2R1R0G5G4G3G2G1G0B4B3B2B1B0 -> 
R4R3R2R1R0 0 0 0 G5G4G3G2G1G0 0 0 B4B3B2B1B0 0 0 0

Regards,
Yi-Lin

-----Original Message-----
From: video4linux-list-bounces@redhat.com
[mailto:video4linux-list-bounces@redhat.com] On Behalf Of Vinay Verma
Sent: Tuesday, May 11, 2010 5:06 PM
To: Carlos Lavin
Cc: video4linux-list
Subject: Re: RGB format

Hi Carlos,

One simple way is to apply simple algebra (unitary method) and to make
out-of-5/6/5 to out-of-8/8/8.
Regards,
Vinay
On Tue, May 11, 2010 at 12:36 PM, Carlos Lavin <
carlos.lavin@vista-silicon.com> wrote:

> hello, I need convert RGB565 to RGB888, but I know how I do it. Can
anybody
> help me??
> --
> video4linux-list mailing list
> Unsubscribe
mailto:video4linux-list-request@redhat.com?subject=unsubscribe
> https://www.redhat.com/mailman/listinfo/video4linux-list
>
--
video4linux-list mailing list
Unsubscribe
mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list

--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
