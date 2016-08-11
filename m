Return-path: <linux-media-owner@vger.kernel.org>
Received: from mga03.intel.com ([134.134.136.65]:43095 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932236AbcHKLr3 (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Thu, 11 Aug 2016 07:47:29 -0400
From: Jani Nikula <jani.nikula@linux.intel.com>
To: Sumit Semwal <sumit.semwal@linaro.org>,
	linux-media@vger.kernel.org, dri-devel@lists.freedesktop.org,
	linaro-mm-sig@lists.linaro.org, linux-doc@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, corbet@lwn.net
Subject: Re: [RFC 3/4] Documentation: move dma-buf documentation to rst
In-Reply-To: <1470912480-32304-4-git-send-email-sumit.semwal@linaro.org>
References: <1470912480-32304-1-git-send-email-sumit.semwal@linaro.org> <1470912480-32304-4-git-send-email-sumit.semwal@linaro.org>
Date: Thu, 11 Aug 2016 14:47:26 +0300
Message-ID: <87twerv86p.fsf@intel.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Thu, 11 Aug 2016, Sumit Semwal <sumit.semwal@linaro.org> wrote:
> diff --git a/Documentation/dma-buf/guide.rst b/Documentation/dma-buf/guide.rst
> new file mode 100644
> index 000000000000..fd3534fdccb3
> --- /dev/null
> +++ b/Documentation/dma-buf/guide.rst
> @@ -0,0 +1,503 @@
> +
> +.. _dma-buf-guide:
> +
> +============================
> +DMA Buffer Sharing API Guide
> +============================
> +
> +Sumit Semwal - sumit.semwal@linaro.org, sumits@kernel.org

Please use the format

:author: Sumit Semwal <sumit.semwal@linaro.org>

---

While on this subject, please excuse me for hijacking the thread a bit.

Personally, I believe it would be better to leave out authorship notes
from documentation and source files in collaborative projects. Of
course, it is only fair that people who deserve credit get the
credit. Listing the authors in the file is often the natural thing to
do, and superficially seems fair.

However, when do you add more names to the list? When has someone
contributed enough to warrant that? Is it fair that the original authors
keep getting the credit for the contributions of others? After a while,
perhaps there is next to nothing left of the original contributions, but
the bar is really high for removing anyone from the authors. Listing the
authors gives the impression this is *their* file, while everyone should
feel welcome to contribute, and everyone who contributes should feel
ownership.

IMHO we would be better off using just the git history for the credits.


BR,
Jani.


PS. I am no saint here, I've got a couple of authors lines myself. I
promise not to add more. I certainly won't chastise anyone for adding
theirs.


-- 
Jani Nikula, Intel Open Source Technology Center
