Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id m5O7aJx2011489
	for <video4linux-list@redhat.com>; Tue, 24 Jun 2008 03:36:19 -0400
Received: from mail8.sea5.speakeasy.net (mail8.sea5.speakeasy.net
	[69.17.117.10])
	by mx3.redhat.com (8.13.8/8.13.8) with ESMTP id m5O7Ypxc014397
	for <video4linux-list@redhat.com>; Tue, 24 Jun 2008 03:34:51 -0400
Date: Tue, 24 Jun 2008 00:34:44 -0700 (PDT)
From: Trent Piepho <xyzzy@speakeasy.org>
To: Brandon Philips <brandon@ifup.org>
In-Reply-To: <20080623233952.GA4569@plankton>
Message-ID: <Pine.LNX.4.58.0806240032081.535@shell2.speakeasy.net>
References: <3dbf42455956d17b8aa6.1214002733@localhost>
	<200806221334.45894.hverkuil@xs4all.nl>
	<20080623150734.GF18397@plankton.ifup.org>
	<200806231800.44274.hverkuil@xs4all.nl>
	<20080623233952.GA4569@plankton>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: v4l-dvb-maintainer@linuxtv.org, video4linux-list@redhat.com,
	mchehab@infradead.org
Subject: Re: [v4l-dvb-maintainer] [PATCH] [PATCH] v4l: Introduce	"index"
 attribute for?persistent video4linux device nodes
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

On Mon, 23 Jun 2008, Brandon Philips wrote:
> +	for (i = 0; i < 32; i++) {
> +		if (used & (1 << i))
> +			continue;
> +		return i;
> +	}

	i = ffz(used);
	return i >= 32 ? -ENFILE : i;

--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
