Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb3-smtp-cloud9.xs4all.net ([194.109.24.30]:60229 "EHLO
        lb3-smtp-cloud9.xs4all.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726622AbeIKUzd (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Tue, 11 Sep 2018 16:55:33 -0400
Subject: Re: [PATCH 1/3] media: use strscpy() instead of strlcpy()
To: Mauro Carvalho Chehab <mchehab+samsung@kernel.org>
Cc: Linux Media Mailing List <linux-media@vger.kernel.org>,
        Mauro Carvalho Chehab <mchehab@infradead.org>,
        Kees Cook <keescook@chromium.org>
References: <cover.1536581757.git.mchehab+samsung@kernel.org>
 <8984cbc7c4af93f8449c5af1cd9b26b620d4fb9f.1536581757.git.mchehab+samsung@kernel.org>
From: Hans Verkuil <hverkuil@xs4all.nl>
Message-ID: <1de0f001-3263-ebde-bd43-8b535ae43553@xs4all.nl>
Date: Tue, 11 Sep 2018 17:55:32 +0200
MIME-Version: 1.0
In-Reply-To: <8984cbc7c4af93f8449c5af1cd9b26b620d4fb9f.1536581757.git.mchehab+samsung@kernel.org>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 09/10/2018 02:19 PM, Mauro Carvalho Chehab wrote:
> The implementation of strscpy() is more robust and safer.
> 
> That's now the recommended way to copy NUL terminated strings.
> 
> Signed-off-by: Mauro Carvalho Chehab <mchehab+samsung@kernel.org>

Acked-by: Hans Verkuil <hans.verkuil@cisco.com>
