Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb3-smtp-cloud9.xs4all.net ([194.109.24.30]:56117 "EHLO
        lb3-smtp-cloud9.xs4all.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726622AbeIKUym (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Tue, 11 Sep 2018 16:54:42 -0400
Subject: Re: [PATCH 2/3 v2] media: replace strcpy() by strscpy()
To: Mauro Carvalho Chehab <mchehab+samsung@kernel.org>,
        Kees Cook <keescook@chromium.org>
Cc: Linux Media Mailing List <linux-media@vger.kernel.org>
References: <cover.1536581757.git.mchehab+samsung@kernel.org>
 <ac8f27b58748f6d474ffd141f29536638f793953.1536581758.git.mchehab+samsung@kernel.org>
 <CAGXu5jKAN6JihMhxz_tMZ6q_Feik3j5RD5QwhuRFmAyiNQJXpA@mail.gmail.com>
 <20180910164847.3f015458@coco.lan> <20180910171415.7eac2732@coco.lan>
 <20180910172042.50792973@coco.lan>
From: Hans Verkuil <hverkuil@xs4all.nl>
Message-ID: <2c3fd691-6f71-233c-5f8c-8d15da4e0b2f@xs4all.nl>
Date: Tue, 11 Sep 2018 17:54:41 +0200
MIME-Version: 1.0
In-Reply-To: <20180910172042.50792973@coco.lan>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 09/10/2018 10:20 PM, Mauro Carvalho Chehab wrote:
> The strcpy() function is being deprecated upstream. Replace
> it by the safer strscpy().
> 
> Signed-off-by: Mauro Carvalho Chehab <mchehab+samsung@kernel.org>

Reviewed-by: Hans Verkuil <hans.verkuil@cisco.com>

Regards,

	Hans
