Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-oi0-f67.google.com ([209.85.218.67]:35265 "EHLO
        mail-oi0-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1756211AbdELTjX (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Fri, 12 May 2017 15:39:23 -0400
MIME-Version: 1.0
In-Reply-To: <632c9564-97f3-7e43-11a5-222ba835889d@xs4all.nl>
References: <20170421105224.899350-1-arnd@arndb.de> <CAK8P3a2V4mUtPNWnFXBBNABqt09vRujRE1w=6wkYc1q63-Ujhg@mail.gmail.com>
 <632c9564-97f3-7e43-11a5-222ba835889d@xs4all.nl>
From: Arnd Bergmann <arnd@arndb.de>
Date: Fri, 12 May 2017 21:39:21 +0200
Message-ID: <CAK8P3a0N54scMtjCjOjqVQRSikhxn3bKBmKSk9VHz1AVGkiLqA@mail.gmail.com>
Subject: Re: [PATCH] [media] cec: improve MEDIA_CEC_RC dependencies
To: Hans Verkuil <hverkuil@xs4all.nl>
Cc: Hans Verkuil <hans.verkuil@cisco.com>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        Benjamin Gaignard <benjamin.gaignard@linaro.org>,
        linux-media@vger.kernel.org,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Fri, May 12, 2017 at 12:00 PM, Hans Verkuil <hverkuil@xs4all.nl> wrote:
> On 05/12/17 11:49, Arnd Bergmann wrote:

>> I can probably come up with a workaround, but haven't completely thought
>> through all the combinations yet. Also, I assume the same fix will be needed
>> for exynos, though that has not come up in randconfig testing so far.
>
> Try this patch:
>
> Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
> ---
> diff --git a/include/media/cec-notifier.h b/include/media/cec-notifier.h
> index eb50ce54b759..da3528c8edb9 100644
> --- a/include/media/cec-notifier.h
> +++ b/include/media/cec-notifier.h
> @@ -29,7 +29,7 @@ struct edid;
>  struct cec_adapter;
>  struct cec_notifier;
>
> -#ifdef CONFIG_MEDIA_CEC_NOTIFIER
> +#if IS_REACHABLE(CONFIG_MEDIA_CEC_NOTIFIER)
>

This misses how CONFIG_MEDIA_CEC_NOTIFIER is just a
 'bool' option to the 'MEDIA_CEC_CORE' symbol that controls
whether the code is built-in or in a module, and it lacks helpers
for cec_notifier_{un,}register.

The version below seems to work, though I don't particularly
like the IS_REACHABLE() addition since that can be confusing
to users.

Signed-off-by: Arnd Bergmann <arnd@arndb.de>

diff --git a/include/media/cec-notifier.h b/include/media/cec-notifier.h
index eb50ce54b759..69f7d8eed1b0 100644
--- a/include/media/cec-notifier.h
+++ b/include/media/cec-notifier.h
@@ -29,7 +29,7 @@ struct edid;
 struct cec_adapter;
 struct cec_notifier;

-#ifdef CONFIG_MEDIA_CEC_NOTIFIER
+#if IS_REACHABLE(CONFIG_CEC_CORE) && IS_ENABLED(CONFIG_MEDIA_CEC_NOTIFIER)

 /**
  * cec_notifier_get - find or create a new cec_notifier for the given device.
@@ -106,6 +106,17 @@ static inline void
cec_notifier_set_phys_addr_from_edid(struct cec_notifier *n,
 {
 }

+static inline void cec_notifier_register(struct cec_notifier *n,
+   struct cec_adapter *adap,
+   void (*callback)(struct cec_adapter *adap, u16 pa))
+{
+}
+
+static inline void cec_notifier_unregister(struct cec_notifier *n)
+{
+}
+
+
 #endif

 #endif
