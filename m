Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp2.goneo.de ([85.220.129.33]:44272 "EHLO smtp2.goneo.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1756026AbcIFPLi (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Tue, 6 Sep 2016 11:11:38 -0400
Content-Type: text/plain; charset=us-ascii
Mime-Version: 1.0 (Mac OS X Mail 6.6 \(1510\))
Subject: Re: [PATCH 1/3] doc-rst:c-domain: fix sphinx version incompatibility
From: Markus Heiser <markus.heiser@darmarit.de>
In-Reply-To: <87k2epxiby.fsf@intel.com>
Date: Tue, 6 Sep 2016 17:10:53 +0200
Cc: Jonathan Corbet <corbet@lwn.net>,
        Mauro Carvalho Chehab <mchehab@infradead.org>,
        Linux Media Mailing List <linux-media@vger.kernel.org>,
        linux-doc@vger.kernel.org
Content-Transfer-Encoding: 8BIT
Message-Id: <3F2C3A86-D578-4978-AFFB-8B34DA758BE6@darmarit.de>
References: <1472657372-21039-1-git-send-email-markus.heiser@darmarit.de> <1472657372-21039-2-git-send-email-markus.heiser@darmarit.de> <20160906061909.36aa2986@lwn.net> <87k2epxiby.fsf@intel.com>
To: Jani Nikula <jani.nikula@intel.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>


Am 06.09.2016 um 15:34 schrieb Jani Nikula <jani.nikula@intel.com>:

> On Tue, 06 Sep 2016, Jonathan Corbet <corbet@lwn.net> wrote:
>> On Wed, 31 Aug 2016 17:29:30 +0200
>> Markus Heiser <markus.heiser@darmarit.de> wrote:
>> 
>>> +            if major >= 1 and minor < 4:
>>> +                # indexnode's tuple changed in 1.4
>>> +                # https://github.com/sphinx-doc/sphinx/commit/e6a5a3a92e938fcd75866b4227db9e0524d58f7c
>>> +                self.indexnode['entries'].append(
>>> +                    ('single', indextext, targetname, ''))
>>> +            else:
>>> +                self.indexnode['entries'].append(
>>> +                    ('single', indextext, targetname, '', None))
>> 
>> So this doesn't seem right.  We'll get the four-entry tuple behavior with
>> 1.3 and the five-entry behavior with 1.4...but what happens when 2.0
>> comes out?
>> 
>> Did you want maybe:
>> 
>> 	if major == 1 and minor < 4:
>> 
>> ?
>> 
>> (That will fail on 0.x, but we've already stated that we don't support
>> below 1.2).
> 
> Is there a way to check the number of entries expected in the tuples
> instead of trying to match the version?

Sadly not, the dissection of the tuple is spread around the source :(

Sphinx has some more of these tuples with fixed length (remember
conf.py, the latex_documents settings) where IMHO hash/value pairs
(dicts) are more suitable.

-- Markus --
> BR,
> Jani.
> -- 
> Jani Nikula, Intel Open Source Technology Center

