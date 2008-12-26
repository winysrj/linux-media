Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id mBQEYZUU004733
	for <video4linux-list@redhat.com>; Fri, 26 Dec 2008 09:34:35 -0500
Received: from cinke.fazekas.hu (cinke.fazekas.hu [195.199.244.225])
	by mx3.redhat.com (8.13.8/8.13.8) with ESMTP id mBQEYMrt023314
	for <video4linux-list@redhat.com>; Fri, 26 Dec 2008 09:34:23 -0500
Date: Fri, 26 Dec 2008 15:34:16 +0100 (CET)
From: Marton Balint <cus@fazekas.hu>
To: video4linux-list@redhat.com
In-Reply-To: <patchbomb.1226272760@roadrunner.athome>
Message-ID: <Pine.LNX.4.64.0812261522110.3125@cinke.fazekas.hu>
References: <patchbomb.1226272760@roadrunner.athome>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: mchehab@infradead.org
Subject: Re: [PATCH 0 of 2] cx88: add optional stereo detection to PAL-BG
 mode with A2 sound system
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

On Mon, 10 Nov 2008, Marton Balint wrote:
> This patchset adds support for optional stereo detection for PAL-BG mode. This
> is a slightly modified version of the original patch I sent to this list
> earlier this year.  The first patch disables the audio thread in cx88, and the
> second implements stereo detection.
> 
> The audio thread in the cx88 code is totally useless, because cx88_get_stereo
> is not implemented correctly. Because of this, the audio thread occaisonally
> sets the audio to MONO after starting a TV application, and unfortuantely this
> may happen after the stereo detection.
> 
> Stereo detection is optional, and is not enabled by default, because it is not
> always reliable, the actual results may depend on your TV application and your
> provider. It works 100% for me using tvtime, and another guy reported success
> earlier, as a result of my original posting.

Has any of the developers reviewed the patches? I know you're busy, but 
please have a look at them, and if they are applicable, apply them :)

Thanks,
  Marton Balint

--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
