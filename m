Return-path: <linux-media-owner@vger.kernel.org>
Received: from mga11.intel.com ([192.55.52.93]:64247 "EHLO mga11.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S932810AbcIFNeo (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Tue, 6 Sep 2016 09:34:44 -0400
From: Jani Nikula <jani.nikula@intel.com>
To: Jonathan Corbet <corbet@lwn.net>,
        Markus Heiser <markus.heiser@darmarit.de>
Cc: Mauro Carvalho Chehab <mchehab@infradead.org>,
        Linux Media Mailing List <linux-media@vger.kernel.org>,
        linux-doc@vger.kernel.org
Subject: Re: [PATCH 1/3] doc-rst:c-domain: fix sphinx version incompatibility
In-Reply-To: <20160906061909.36aa2986@lwn.net>
References: <1472657372-21039-1-git-send-email-markus.heiser@darmarit.de> <1472657372-21039-2-git-send-email-markus.heiser@darmarit.de> <20160906061909.36aa2986@lwn.net>
Date: Tue, 06 Sep 2016 16:34:41 +0300
Message-ID: <87k2epxiby.fsf@intel.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Tue, 06 Sep 2016, Jonathan Corbet <corbet@lwn.net> wrote:
> On Wed, 31 Aug 2016 17:29:30 +0200
> Markus Heiser <markus.heiser@darmarit.de> wrote:
>
>> +            if major >= 1 and minor < 4:
>> +                # indexnode's tuple changed in 1.4
>> +                # https://github.com/sphinx-doc/sphinx/commit/e6a5a3a92e938fcd75866b4227db9e0524d58f7c
>> +                self.indexnode['entries'].append(
>> +                    ('single', indextext, targetname, ''))
>> +            else:
>> +                self.indexnode['entries'].append(
>> +                    ('single', indextext, targetname, '', None))
>
> So this doesn't seem right.  We'll get the four-entry tuple behavior with
> 1.3 and the five-entry behavior with 1.4...but what happens when 2.0
> comes out?
>
> Did you want maybe:
>
> 	if major == 1 and minor < 4:
>
> ?
>
> (That will fail on 0.x, but we've already stated that we don't support
> below 1.2).

Is there a way to check the number of entries expected in the tuples
instead of trying to match the version?

BR,
Jani.




-- 
Jani Nikula, Intel Open Source Technology Center
