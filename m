Return-path: <linux-media-owner@vger.kernel.org>
Received: from aer-iport-4.cisco.com ([173.38.203.54]:19813 "EHLO
        aer-iport-4.cisco.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750726AbdGGLQt (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Fri, 7 Jul 2017 07:16:49 -0400
Subject: Re: [PATCH v7 2/6] [media] cec-notifier.h: Prevent build warnings
 using forward declaration
To: Jose Abreu <Jose.Abreu@synopsys.com>, linux-media@vger.kernel.org,
        linux-kernel@vger.kernel.org
References: <cover.1499425271.git.joabreu@synopsys.com>
 <e0e455ac3f40b3dd0344127bbb8773cea579620e.1499425271.git.joabreu@synopsys.com>
Cc: Carlos Palminha <CARLOS.PALMINHA@synopsys.com>,
        Hans Verkuil <hans.verkuil@cisco.com>
From: Hans Verkuil <hansverk@cisco.com>
Message-ID: <4e42b0be-fdef-b4d6-be92-ccce71dda49d@cisco.com>
Date: Fri, 7 Jul 2017 13:16:46 +0200
MIME-Version: 1.0
In-Reply-To: <e0e455ac3f40b3dd0344127bbb8773cea579620e.1499425271.git.joabreu@synopsys.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 07/07/17 13:08, Jose Abreu wrote:
> When CONFIC_CEC_NOTIFIER is not set and we only include cec-notifier.h
> we can get build warnings like these ones:
> 
> "warning: ‘struct cec_notifier’ declared inside parameter list will
> not be visible outside of this definition or declaration"
> 
> Prevent these warnings by using forward declaration of notifier
> structure.
> 
> Signed-off-by: Jose Abreu <joabreu@synopsys.com>
> Cc: Carlos Palminha <palminha@synopsys.com>
> Cc: Hans Verkuil <hans.verkuil@cisco.com>
> ---
>  include/media/cec-notifier.h | 6 +++---
>  1 file changed, 3 insertions(+), 3 deletions(-)
> 
> diff --git a/include/media/cec-notifier.h b/include/media/cec-notifier.h
> index 298f996..84f9376 100644
> --- a/include/media/cec-notifier.h
> +++ b/include/media/cec-notifier.h
> @@ -21,14 +21,14 @@
>  #ifndef LINUX_CEC_NOTIFIER_H
>  #define LINUX_CEC_NOTIFIER_H
>  
> -#include <linux/types.h>
> -#include <media/cec.h>
> -
>  struct device;
>  struct edid;
>  struct cec_adapter;
>  struct cec_notifier;
>  
> +#include <linux/types.h>
> +#include <media/cec.h>
> +
>  #if IS_REACHABLE(CONFIG_CEC_CORE) && IS_ENABLED(CONFIG_CEC_NOTIFIER)
>  
>  /**
> 

Isn't it enough to add a forward declaration of cec_notifier in the previous
patch? E.g.:

+#ifndef CONFIG_CEC_NOTIFIER
+struct cec_notifier;
+static inline void cec_register_cec_notifier(struct cec_adapter *adap,
+					     struct cec_notifier *notifier)
+{
+}
+#endif

Then this header doesn't need to change.

Regards,

	Hans
