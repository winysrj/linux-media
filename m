Return-path: <linux-media-owner@vger.kernel.org>
Received: from mga11.intel.com ([192.55.52.93]:50114 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752250AbcHJSu2 (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Wed, 10 Aug 2016 14:50:28 -0400
From: Jani Nikula <jani.nikula@intel.com>
To: Mauro Carvalho Chehab <mchehab@infradead.org>
Cc: Mauro Carvalho Chehab <mchehab@s-opensource.com>,
	Hans Verkuil <hverkuil@xs4all.nl>,
	Linux Media Mailing List <linux-media@vger.kernel.org>,
	Jonathan Corbet <corbet@lwn.net>, linux-doc@vger.kernel.org,
	Markus Heiser <markus.heiser@darmarit.de>,
	Daniel Vetter <daniel.vetter@ffwll.ch>
Subject: Re: parts of media docs sphinx re-building every time?
In-Reply-To: <20160810054755.0175f331@vela.lan>
References: <8760rbp8zh.fsf@intel.com> <20160810054755.0175f331@vela.lan>
Date: Wed, 10 Aug 2016 12:23:16 +0300
Message-ID: <87k2fpvuyj.fsf@intel.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Wed, 10 Aug 2016, Mauro Carvalho Chehab <mchehab@infradead.org> wrote:
> Em Mon, 08 Aug 2016 18:37:38 +0300
> Jani Nikula <jani.nikula@intel.com> escreveu:
>
>> Hi Mauro & co -
>> 
>> I just noticed running 'make htmldocs' rebuilds parts of media docs
>> every time on repeated runs. This shouldn't happen. Please investigate.
>
> I was unable to reproduce it here. Are you passing any special options
> to the building system?

Hmh, I can't reproduce this now either. I was able to hit this on
another machine consistently, even with 'make cleandocs' in
between. I'll check the environment on the other machine when I get my
hands on it.

BR,
Jani.

-- 
Jani Nikula, Intel Open Source Technology Center
