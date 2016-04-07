Return-path: <linux-media-owner@vger.kernel.org>
Received: from mgwkm02.jp.fujitsu.com ([202.219.69.169]:59015 "EHLO
	mgwkm02.jp.fujitsu.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752222AbcDGBxr (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Wed, 6 Apr 2016 21:53:47 -0400
Subject: Re: Security Fix for CVE-2015-7833
To: sasha.levin@oracle.com
References: <570477DE.30705@jp.fujitsu.com>
Cc: linux-media@vger.kernel.org, stable@vger.kernel.org
From: Yuki Machida <machida.yuki@jp.fujitsu.com>
Message-ID: <5705BD9D.6030205@jp.fujitsu.com>
Date: Thu, 7 Apr 2016 10:53:33 +0900
MIME-Version: 1.0
In-Reply-To: <570477DE.30705@jp.fujitsu.com>
Content-Type: text/plain; charset=iso-2022-jp
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Sasha,

On 2016年04月06日 11:43, Yuki Machida wrote:
> Hi Sasha,
> 
> I conformed that these patches for CVE-2015-7833 not applied at v4.1.20.
> 588afcc1c0e45358159090d95bf7b246fb67565
> fa52bd506f274b7619955917abfde355e3d19ff
I conformed that these patches not applied at v4.1.21.

> Could you please apply this CVE-2015-7833 fix for 4.1-stable ?
> 
> References:
> https://security-tracker.debian.org/tracker/CVE-2015-7833
> http://git.linuxtv.org/cgit.cgi/media_tree.git/commit?id=588afcc1c0e45358159090d95bf7b246fb67565
> http://git.linuxtv.org/cgit.cgi/media_tree.git/commit?id=fa52bd506f274b7619955917abfde355e3d19ff

These patches are already included since v4.5-rc1 in mainline.
https://git.kernel.org/cgit/linux/kernel/git/torvalds/linux.git/commit/?id=588afcc1c0e45358159090d95bf7b246fb67565f
https://git.kernel.org/cgit/linux/kernel/git/torvalds/linux.git/commit/?id=fa52bd506f274b7619955917abfde355e3d19ffe

> 
> Regards,
> Yuki Machida
> --
> To unsubscribe from this list: send the line "unsubscribe linux-media" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 
