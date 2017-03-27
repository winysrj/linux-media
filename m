Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-it0-f68.google.com ([209.85.214.68]:34791 "EHLO
        mail-it0-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752109AbdC0NC7 (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Mon, 27 Mar 2017 09:02:59 -0400
Received: by mail-it0-f68.google.com with SMTP id e75so4050988itd.1
        for <linux-media@vger.kernel.org>; Mon, 27 Mar 2017 06:02:15 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <1490614949-30985-1-git-send-email-vaibhavddit@gmail.com>
References: <1490610746-28579-1-git-send-email-vaibhavddit@gmail.com> <1490614949-30985-1-git-send-email-vaibhavddit@gmail.com>
From: Varsha Rao <rvarsha016@gmail.com>
Date: Mon, 27 Mar 2017 18:31:34 +0530
Message-ID: <CAAFX7JRthVr9jPto39KxtF8yngGa-m8BYEmSiq82db4rHF615g@mail.gmail.com>
Subject: Re: [PATCH] staging:media:atomisp:i2c removed unnecessary white space
 before comma in memset()
To: vaibhavddit@gmail.com
Cc: Mauro Carvalho Chehab <mchehab@kernel.org>,
        linux-media@vger.kernel.org, devel@driverdev.osuosl.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Mon, Mar 27, 2017 at 5:12 PM,  <vaibhavddit@gmail.com> wrote:
> From: Vaibhav Kothari <vaibhavddit@gmail.com>

"From: .." should not be included in the patch. The subject is still
incorrect, there should be a space after each colon. The subject
should give overview of changes made in the patch.
It is preferred to fix single checkpatch issue in a patch.

> - Fixing up check-patch error & Warnings
> - Added blank line between declaration and defination
>   at various places

The commit message is not proper. There are no full stops at the
end of any sentence. Also change defination to definition.
Check git log for example.

static int gc2235_read_reg(struct i2c_client *client,
>                 return -EINVAL;
>         }
>
> -       memset(msg, 0 , sizeof(msg));
> +       memset(msg, 0, sizeof(msg));

This change is not reflected in commit message.

>         if (is_init == 0) {
>                 /* force gc2235 to do a reset in res change, otherwise it
> -               * can not output normal after switching res. and it is not
> -               * necessary for first time run up after power on, for the sack
> -               * of performance
> -               */
> +                * can not output normal after switching res. and it is not
> +                * necessary for first time run up after power on, for the sack
> +                * of performance
> +                */

Even this change fixes a different issue.

Send patch for a single checkpatch issue.

https://kernelnewbies.org/FirstKernelPatch#submit%2Ba%2Bpatch
Check the First Kernel Patch page.

Thanks,
Varsha Rao
