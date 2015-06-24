Return-path: <linux-media-owner@vger.kernel.org>
Received: from rcdn-iport-1.cisco.com ([173.37.86.72]:55013 "EHLO
	rcdn-iport-1.cisco.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752003AbbFXN5F convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 24 Jun 2015 09:57:05 -0400
Received: from xhc-aln-x14.cisco.com (xhc-aln-x14.cisco.com [173.36.12.88])
	by alln-core-12.cisco.com (8.14.5/8.14.5) with ESMTP id t5ODv4Sq029439
	(version=TLSv1/SSLv3 cipher=AES128-SHA bits=128 verify=FAIL)
	for <linux-media@vger.kernel.org>; Wed, 24 Jun 2015 13:57:05 GMT
From: "Prashant Laddha (prladdha)" <prladdha@cisco.com>
To: "Prashant Laddha (prladdha)" <prladdha@cisco.com>,
	"linux-media@vger.kernel.org" <linux-media@vger.kernel.org>
Subject: Re: [RFC PATCH v2 0/2] Support for reduced fps in v4l2-utils
Date: Wed, 24 Jun 2015 13:57:04 +0000
Message-ID: <D1B0B4D9.4E899%prladdha@cisco.com>
References: <1435153935-11403-1-git-send-email-prladdha@cisco.com>
In-Reply-To: <1435153935-11403-1-git-send-email-prladdha@cisco.com>
Content-Language: en-US
Content-Type: text/plain; charset="us-ascii"
Content-ID: <34F87736F2C2934283FA47943B98A670@emea.cisco.com>
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Please ignore v2 patches. By mistake I posted v1 again.

On 24/06/15 7:22 pm, "Prashant Laddha (prladdha)" <prladdha@cisco.com>
wrote:

>Change compared to v1:
>Updated function description that was missed in v1.
>
>Prashant Laddha (2):
>  v4l2-utils: add support for reduced fps in cvt modeline
>  v4l2-utils: extend set-dv-timings to support reduced fps
>
> utils/v4l2-ctl/v4l2-ctl-modes.cpp |  6 +++++-
> utils/v4l2-ctl/v4l2-ctl-stds.cpp  | 14 ++++++++++++--
> utils/v4l2-ctl/v4l2-ctl.h         |  3 ++-
> 3 files changed, 19 insertions(+), 4 deletions(-)
>
>-- 
>1.9.1
>
>--
>To unsubscribe from this list: send the line "unsubscribe linux-media" in
>the body of a message to majordomo@vger.kernel.org
>More majordomo info at  http://vger.kernel.org/majordomo-info.html

