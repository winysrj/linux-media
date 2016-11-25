Return-path: <linux-media-owner@vger.kernel.org>
Received: from galahad.ideasonboard.com ([185.26.127.97]:38270 "EHLO
        galahad.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750916AbcKYCCn (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Thu, 24 Nov 2016 21:02:43 -0500
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: Sakari Ailus <sakari.ailus@linux.intel.com>
Cc: linux-media@vger.kernel.org
Subject: Re: [PATCH 1/1] media: Drop FSF's postal address from the source code files
Date: Fri, 25 Nov 2016 04:03:04 +0200
Message-ID: <13836325.hF0BpjAJel@avalon>
In-Reply-To: <1477658633-2536-1-git-send-email-sakari.ailus@linux.intel.com>
References: <1477658633-2536-1-git-send-email-sakari.ailus@linux.intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Sakari,

Thank you for the patch.

On Friday 28 Oct 2016 15:43:53 Sakari Ailus wrote:
> Drop the FSF's postal address from the source code files that typically
> contain mostly the license text. The patch has been created with the
> following command without manual edits:
> 
> git grep -l "675 Mass Ave\|59 Temple Place\|51 Franklin St" -- \
> 	drivers/media/ include/media|while read i; do i=$i perl -e '
> open(F,"< $ENV{i}");
> $a=join("", <F>);
> $a =~ s/[ \t]*\*\n.*You should.*\n.*along with.*\n.*(\n.*USA.*$)?\n//m
> 	&& $a =~ s/(^.*)Or, (point your browser to) /$1To obtain the license,
> $2\n$1/m; close(F);

Do we really need to keep the "To obtain the license, point your browser 
to..." text ?

In any case,

Acked-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>

with a quick review of the loooooong patch directly from your tree.

> open(F, "> $ENV{i}");
> print F $a;
> close(F);'; done
> 
> Signed-off-by: Sakari Ailus <sakari.ailus@linux.intel.com>
> ---
> Hi,
> 
> I found this in a few places and decided to remove them all. The script
> could be useful elsewhere, too.
> 
> The actual patch can be found here, it appears to be too large to be
> accepted by vger:
> 
> <URL:http://git.retiisi.org.uk/?p=~sailus/linux.git;a=commitdiff;h=refs/head
> s/fsf-address>

-- 
Regards,

Laurent Pinchart

