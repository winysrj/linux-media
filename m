Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-pg1-f194.google.com ([209.85.215.194]:39216 "EHLO
        mail-pg1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727339AbeKDBKD (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Sat, 3 Nov 2018 21:10:03 -0400
Received: by mail-pg1-f194.google.com with SMTP id r9-v6so2288021pgv.6
        for <linux-media@vger.kernel.org>; Sat, 03 Nov 2018 08:58:22 -0700 (PDT)
Date: Sat, 3 Nov 2018 21:28:14 +0530
From: Himanshu Jha <himanshujha199640@gmail.com>
To: Irenge Jules Bashizi <jbi.octave@gmail.com>
Cc: linux-media@vger.kernel.org, gregkh@linuxfoundation.org,
        julia.lawall@lip6.fr, outreachy-kernel@googlegroups.com,
        jules.octave@outlook.com
Subject: Re: [Outreachy kernel] [PATCH] staging:media:Add
 SPDX-License-Identifier
Message-ID: <20181103155814.GA9411@himanshu-Vostro-3559>
References: <20181103111648.30662-1-jbi.octave@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20181103111648.30662-1-jbi.octave@gmail.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Sat, Nov 03, 2018 at 11:16:48AM +0000, Irenge Jules Bashizi wrote:
> Add SPDX-License-Identifier to fix missing license tag checkpatch warning
> 
> Signed-off-by: Irenge Jules Bashizi <jbi.octave@gmail.com>
> ---
>  drivers/staging/media/davinci_vpfe/davinci_vpfe_user.h | 4 +---
>  1 file changed, 1 insertion(+), 3 deletions(-)
> 
> diff --git a/drivers/staging/media/davinci_vpfe/davinci_vpfe_user.h b/drivers/staging/media/davinci_vpfe/davinci_vpfe_user.h
> index 7cc115c9ebe6..6d2570a63529 100644
> --- a/drivers/staging/media/davinci_vpfe/davinci_vpfe_user.h
> +++ b/drivers/staging/media/davinci_vpfe/davinci_vpfe_user.h
> @@ -1,3 +1,4 @@
> +/* SPDX-License-Identifier: GPL-2.0 */
>  /*
>   * Copyright (C) 2012 Texas Instruments Inc
>   *
> @@ -10,9 +11,6 @@
>   * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
>   * GNU General Public License for more details.
>   *
> - * You should have received a copy of the GNU General Public License
> - * along with this program; if not, write to the Free Software
> - * Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA  02111-1307 USA

Read Documentation/process/license-rules.rst and try to understand why
SPDX was introduced ?

Hint: search for "boilerplate" in license-rules.rst

Or search for previosuly accepted patches on SPDX ...


-- 
Himanshu Jha
Undergraduate Student
Department of Electronics & Communication
Guru Tegh Bahadur Institute of Technology
