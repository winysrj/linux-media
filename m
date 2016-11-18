Return-path: <linux-media-owner@vger.kernel.org>
Received: from 7of9.schinagl.nl ([88.159.158.68]:44526 "EHLO 7of9.schinagl.nl"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752578AbcKRVMN (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Fri, 18 Nov 2016 16:12:13 -0500
Subject: Re: [PATCH dtv-scan-tables] Rename pl-Krosno_Sucha_Gora with only
 ASCII characters
To: Thomas Petazzoni <thomas.petazzoni@free-electrons.com>,
        linux-media@vger.kernel.org,
        Mauro Carvalho Chehab <mchehab@osg.samsung.com>
References: <1479157550-983-1-git-send-email-thomas.petazzoni@free-electrons.com>
From: Olliver Schinagl <oliver@schinagl.nl>
Message-ID: <3081b3c9-4822-a40f-b119-5a75b65e3869@schinagl.nl>
Date: Fri, 18 Nov 2016 22:05:02 +0100
MIME-Version: 1.0
In-Reply-To: <1479157550-983-1-git-send-email-thomas.petazzoni@free-electrons.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hey Thomas,

On 14-11-16 22:05, Thomas Petazzoni wrote:
> The pl-Krosno_Sucha_Gora file, added in commit
> 4cb113fd15e562f0629000fcad9f41405595198d, is the only file that
> contains non-ASCII characters in the tree. This causes a number of
> build issues with other packages that don't necessarily handle very
> well non-ASCII file name encodings.
>
> Since no other file in the tree contain non-ASCII characters in their
> name, this commit renames pl-Krosno_Sucha_Gora similarly.
>
> Examples of files that are named with only ASCII characters even if
> the city name really contains non-ASCII characters:
>
>    - pl-Wroclaw should be written pl-Wrocław
>    - se-Laxsjo should be written se-Laxsjö
>    - de-Dusseldorf should be written de-Düsseldorf
>    - vn-Thaibinh should be written vn-Thái_Bình
>
> Since there is no real standardization on the encoding of file names,
> we'd better be safe and use only ASCII characters.
>
> Signed-off-by: Thomas Petazzoni <thomas.petazzoni@free-electrons.com>
> ---
>   "dvb-t/pl-Krosno_Sucha_G\303\263ra" => dvb-t/pl-Krosno_Sucha_Gora | 0
>   1 file changed, 0 insertions(+), 0 deletions(-)
>   rename "dvb-t/pl-Krosno_Sucha_G\303\263ra" => dvb-t/pl-Krosno_Sucha_Gora (100%)
>
> diff --git "a/dvb-t/pl-Krosno_Sucha_G\303\263ra" b/dvb-t/pl-Krosno_Sucha_Gora
> similarity index 100%
> rename from "dvb-t/pl-Krosno_Sucha_G\303\263ra"
> rename to dvb-t/pl-Krosno_Sucha_Gora

I agree for consistency sake and ease of use, to use plain ascii for 
pl-Krosno_Sucha_Gora as well. If someone feels that we should follow 
proper spelling using UTF-8, someone should fix up and correct all names 
in 1 rename patch.

Also there are various downstream users, which may simply not support 
UTF-8. So by using ascii we also reduce the risk of trouble there.


Thank you for the patch and it has been merged.


Olliver

