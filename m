Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-pf0-f194.google.com ([209.85.192.194]:33562 "EHLO
        mail-pf0-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751773AbdFHOTN (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Thu, 8 Jun 2017 10:19:13 -0400
Received: by mail-pf0-f194.google.com with SMTP id f27so5299333pfe.0
        for <linux-media@vger.kernel.org>; Thu, 08 Jun 2017 07:19:13 -0700 (PDT)
Received: from ubuntu.windy (c122-106-153-7.carlnfd1.nsw.optusnet.com.au. [122.106.153.7])
        by smtp.gmail.com with ESMTPSA id q194sm9964112pfq.56.2017.06.08.07.19.10
        for <linux-media@vger.kernel.org>
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 08 Jun 2017 07:19:11 -0700 (PDT)
Date: Fri, 9 Jun 2017 00:19:28 +1000
From: Vincent McIntyre <vincent.mcintyre@gmail.com>
To: linux-media@vger.kernel.org
Subject: Re: [media_build] regression at 3a17e11 "update
 v4.10_sched_signal.patch"
Message-ID: <20170608141926.GA16444@ubuntu.windy>
References: <20170608131339.GA11167@ubuntu.windy>
 <20170608132826.GB11167@ubuntu.windy>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20170608132826.GB11167@ubuntu.windy>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

> 
> $ cat drivers/media/rc/lirc_dev.c.rej
> --- drivers/media/rc/lirc_dev.c
> +++ drivers/media/rc/lirc_dev.c
> @@ -18,7 +18,7 @@
>  #define pr_fmt(fmt) KBUILD_MODNAME ": " fmt
>  
>  #include <linux/module.h>
> -#include <linux/sched/signal.h>
> +#include <linux/sched.h>
>  #include <linux/ioctl.h>
>  #include <linux/poll.h>
>  #include <linux/mutex.h>
> 

A bit of staring brings this to light:

The file that is being patched has extra lines relative to the patch

     18 #undef pr_fmt
     19 #define pr_fmt(fmt) KBUILD_MODNAME ": " fmt
     20 
     21 #include <linux/module.h>
**   22 #include <linux/kernel.h>
     23 #include <linux/sched/signal.h>
**   24 #include <linux/errno.h>
     25 #include <linux/ioctl.h>
     26 #include <linux/fs.h>
     27 #include <linux/poll.h>
     28 #include <linux/completion.h>
     29 #include <linux/mutex.h>
     30 #include <linux/wait.h>

This hunk applies cleanly, and seems to match up with recent kernel
code (eg
   174cd4b1e5fbd0d74c68cf3a74f5bd4923485512
   sched/headers: Prepare to move signal wakeup & sigpending methods
    from <linux/sched.h> into <linux/sched/signal.h>)

@@ -20,7 +20,7 @@
 
 #include <linux/module.h>
 #include <linux/kernel.h>
-#include <linux/sched/signal.h>
+#include <linux/sched.h>
 #include <linux/errno.h>
 #include <linux/ioctl.h>
 #include <linux/fs.h>

HTH
Vince
