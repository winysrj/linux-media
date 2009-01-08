Return-path: <video4linux-list-bounces@redhat.com>
Date: Thu, 8 Jan 2009 02:37:42 -0200
From: Mauro Carvalho Chehab <mchehab@infradead.org>
To: "Nam =?UTF-8?B?UGjhuqFtIFRow6BuaA==?=" <phamthanhnam.ptn@gmail.com>
Message-ID: <20090108023742.20551da6@pedra.chehab.org>
In-Reply-To: <2ac79fa40901072007m1f2edferacbc6e1da19bfeac@mail.gmail.com>
References: <2ac79fa40901072007m1f2edferacbc6e1da19bfeac@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Cc: video4linux-list@redhat.com,
	Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: Re: [PATCH] pwc: add support for webcam snapshot button
List-Unsubscribe: <https://www.redhat.com/mailman/listinfo/video4linux-list>,
	<mailto:video4linux-list-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/mailman/private/video4linux-list>
List-Post: <mailto:video4linux-list@redhat.com>
List-Help: <mailto:video4linux-list-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/video4linux-list>,
	<mailto:video4linux-list-request@redhat.com?subject=subscribe>
Sender: video4linux-list-bounces@redhat.com
Errors-To: video4linux-list-bounces@redhat.com
List-ID: <linux-media.vger.kernel.org>

Hi Nam,

On Thu, 8 Jan 2009 11:07:20 +0700
"Nam Phạm Thành" <phamthanhnam.ptn@gmail.com> wrote:

> Hi all,
> I read somewhere that official support for pwc driver has been stopped :(
> This patch adds support for Philips webcam snapshot button as an event input
> device, for consistency with other webcam drivers (uvc, quickcam messenger,
> konicawc...)
> Tested with input-utils (http://dl.bytesex.org/cvs-snapshots/) for Logitech
> QuickCam Notebook Pro (046d:08b1) et Logitech QuickCam Pro 4000 (046d:08b2).
> This patch doesn't touch other features, so it is very likely that it won't
> break anything.
> Return to my previous question "How to use webcam snapshot button?". Noone
> answered. I think that support for it has already existed in driver, but at
> the present, there isn't any application which exploited this feature yet.

Please, take a look at http://linuxtv.org/hg/v4l-dvb/raw-file/tip/README.patches
before submitting a patch.

Basically, you should never submit a patch on zip format, since scripts don't
work. Also, always c/c linux-media ML for development issues and patches.

The format of the email also need to follow the stated rules on README.patches,
to be properly handled by patchwork.kernel.org (the tool we use to get the
patches and apply).

Also, please review the format of the patch before submitting (with make
checkpatch), to be sure that it is following the Coding Style used on Linux.

Cheers,
Mauro

--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
