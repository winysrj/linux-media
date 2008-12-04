Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id mB48JGNn014666
	for <video4linux-list@redhat.com>; Thu, 4 Dec 2008 03:19:16 -0500
Received: from smtp5-g19.free.fr (smtp5-g19.free.fr [212.27.42.35])
	by mx3.redhat.com (8.13.8/8.13.8) with ESMTP id mB48J2n2017967
	for <video4linux-list@redhat.com>; Thu, 4 Dec 2008 03:19:02 -0500
From: Jean-Francois Moine <moinejf@free.fr>
To: Jim Paris <jim@jtan.com>
In-Reply-To: <patchbomb.1228337219@hypnosis.jim>
References: <patchbomb.1228337219@hypnosis.jim>
Content-Type: text/plain; charset=ISO-8859-1
Date: Thu, 04 Dec 2008 09:14:02 +0100
Message-Id: <1228378442.1733.17.camel@localhost>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Cc: video4linux-list@redhat.com
Subject: Re: [PATCH 0 of 4] ov534 patches
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

On Wed, 2008-12-03 at 15:46 -0500, Jim Paris wrote:
> Hi,

Hi Jim,

> Here are some ov534 patches I've been working on.
> 
> ov534: don't check status twice
> ov534: initialization cleanup
> ov534: Fix frame size so we don't miss the last pixel
> ov534: frame transfer improvements

Thank you for these patchs. Some changes were already done in my
repository. I merged them and pushed. May you check if everything is
correct?

Also, I moved the last fid and pts to the sd structure. This allows many
webcams to work simultaneously. I was wondering about the reset of these
variables: last_fid is never reset and last_pts is reset on
UVC_STREAM_EOF. Shouldn't they also be reset on streaming start?

Cheers.

-- 
Ken ar c'hentañ |             ** Breizh ha Linux atav! **
Jef             |               http://moinejf.free.fr/


--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
