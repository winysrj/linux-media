Return-path: <linux-media-owner@vger.kernel.org>
Received: from kozue.soulik.info ([108.61.222.116]:59267 "EHLO
	kozue.soulik.info" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751090AbaGDEep (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Fri, 4 Jul 2014 00:34:45 -0400
Message-ID: <53B62ED8.6030400@soulik.info>
Date: Fri, 04 Jul 2014 12:34:32 +0800
From: ayaka <ayaka@soulik.info>
MIME-Version: 1.0
To: linux-media@vger.kernel.org
CC: Pawel Osciak <posciak@chromium.org>, k.debski@samsung.com,
	kyungmin.park@samsung.com, jtp.park@samsung.com,
	m.chehab@samsung.com, arun.kk@samsung.com
Subject: Re: [PATCH] s5p-mfc: encoder handles buffers freeing
References: <1404445164-13625-1-git-send-email-ayaka@soulik.info> <CACHYQ-qJ+seYs3pGW=4-1Y8W4zpM_Xeoaq+L8wJhVXWBiyf1_g@mail.gmail.com>
In-Reply-To: <CACHYQ-qJ+seYs3pGW=4-1Y8W4zpM_Xeoaq+L8wJhVXWBiyf1_g@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>


-----BEGIN PGP SIGNED MESSAGE-----
Hash: SHA1


于 2014年07月04日 12:13, Pawel Osciak 写道:
> Hi,
>
> On Fri, Jul 4, 2014 at 12:39 PM, ayaka <ayaka@soulik.info
<mailto:ayaka@soulik.info>> wrote:
>
>     Add handling of buffer freeing reqbufs request to the encoder of
>     s5p-mfc.
>
>     Signed-off-by: ayaka <ayaka@soulik.info <mailto:ayaka@soulik.info>>
>
>
> We've had a verified and tested fix for this in ChromeOS tree for some
time now, but haven't gotten to upstreaming it yet. It's a combination
of the below two diffs:
>
>
https://chromium-review.googlesource.com/#/c/65926/2/drivers/media/platform/s5p-mfc/s5p_mfc_enc.c
>
https://chromium-review.googlesource.com/#/c/66624/2/drivers/media/platform/s5p-mfc/s5p_mfc_enc.c
>
> Have you tested and verified your patch? Unless I'm looking at a
different base, it will not work, because:
Yes I have do a little test, but the patch was for gstreamer project, it
mainly used it on buffer allocation detecting, so I forget it again even
I have been told.
> - the call to reqbufs it too late and will not execute, because the check for state != QUEUE_FREE
above it will be true and you'll hit the early return;
> - it will also leak private buffer memory, as you can see in the above
patches, you also need to release_codec_buffers on the OUTPUT queue.
>
Please ignore my patch, I am so careless and making so much mistake and
I didn't know a project have done that. Thank you for telling me that.
> Thanks,
> Pawel
>
> 
>
>     ---
>      drivers/media/platform/s5p-mfc/s5p_mfc_enc.c | 10 ++++++++++
>      1 file changed, 10 insertions(+)
>
>     diff --git a/drivers/media/platform/s5p-mfc/s5p_mfc_enc.c
b/drivers/media/platform/s5p-mfc/s5p_mfc_enc.c
>     index d26b248..74fb80b 100644
>     --- a/drivers/media/platform/s5p-mfc/s5p_mfc_enc.c
>     +++ b/drivers/media/platform/s5p-mfc/s5p_mfc_enc.c
>     @@ -1166,6 +1166,11 @@ static int vidioc_reqbufs(struct file
*file, void *priv,
>                             mfc_err("error in vb2_reqbufs() for E(D)\n");
>                             return ret;
>                     }
>     +               if (reqbufs->count == 0) {
>     +                       mfc_debug(2, "Freeing buffers\n");
>     +                       ctx->capture_state = QUEUE_FREE;
>     +                       return ret;
>     +               }
>                     ctx->capture_state = QUEUE_BUFS_REQUESTED;
>
>                     ret = s5p_mfc_hw_call(ctx->dev->mfc_ops,
>     @@ -1200,6 +1205,11 @@ static int vidioc_reqbufs(struct file
*file, void *priv,
>                             mfc_err("error in vb2_reqbufs() for E(S)\n");
>                             return ret;
>                     }
>     +               if (reqbufs->count == 0) {
>     +                       mfc_debug(2, "Freeing buffers\n");
>     +                       ctx->output_state = QUEUE_FREE;
>     +                       return ret;
>     +               }
>                     ctx->output_state = QUEUE_BUFS_REQUESTED;
>             } else {
>                     mfc_err("invalid buf type\n");
>     --
>     1.9.3
>
>     --
>     To unsubscribe from this list: send the line "unsubscribe
linux-media" in
>     the body of a message to majordomo@vger.kernel.org
<mailto:majordomo@vger.kernel.org>
>     More majordomo info at  http://vger.kernel.org/majordomo-info.html
>
>

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1
Comment: Using GnuPG with Thunderbird - http://www.enigmail.net/

iQIcBAEBAgAGBQJTti7PAAoJEPsGh4kgR4i5peYQAIZYX8rWsiPnG4SDo4DryffI
g8CnfNr6ndmgxbKiW4OLceSmFmWwmrJj+JQT5fMtO7psAhRL3VmsTZOAn5eMxkpc
z4+/etqF+vKCR/UJf6MeUN/Q4P4RitFulWNGgSfBP0DWoQcxTVdFFSfWBMAEKClI
+11IbN/5IEvRNcGfc9S4sZxwuTOyxrPCMT+X8LayO8zDBC/qMpoOjlFMH2buPCu7
SsvEMjk6AZtIl7oTSF7saPO+Y6C13vuJZHcjCLI7rZlJb5+JajorERNMTqnYZb9j
Qa9jeeTqjtsA42L3y+JUNh6TPjXlF0dZYFfMBQvvaKBNyvKbB+jXkujUJpLZY09F
6baVb/JQlkCehLhi7GUlhKtghgDxXBRBGmw0U7FMA6C4pDr8Z67O4ePdfM1MmPbV
FwBjDALWJuioWiSwZFzhU/lzAhypN5EFKNMKa+pS8SJuU9S1PwURP3VQaV8y7urR
NTsiHyC53JL5wYzfn52jQMcYOC06W+ABjlB2i4L2kmSxfNrexdWZbIH0VLTaHKqt
e1Wl1ZDLXYjE8UXfxbmIOLaSYOPRc5iAkXfB1PpTlETdIvc0znC/dV7xPY2Im6p3
Yc6FnDus6oSP4Lxo+NrIGs4TcqF2cTvHu7QPikFTRIr1bCD1NFTp3L8w1Jlk999q
72b9+Bg5FebefLBseNi1
=3KV/
-----END PGP SIGNATURE-----

