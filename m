Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp1.goneo.de ([85.220.129.30]:60310 "EHLO smtp1.goneo.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1753617AbcIFMYh (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Tue, 6 Sep 2016 08:24:37 -0400
Content-Type: text/plain; charset=us-ascii
Mime-Version: 1.0 (Mac OS X Mail 6.6 \(1510\))
Subject: Re: [PATCH 1/3] doc-rst:c-domain: fix sphinx version incompatibility
From: Markus Heiser <markus.heiser@darmarit.de>
In-Reply-To: <20160906061909.36aa2986@lwn.net>
Date: Tue, 6 Sep 2016 14:24:11 +0200
Cc: Mauro Carvalho Chehab <mchehab@infradead.org>,
        Jani Nikula <jani.nikula@intel.com>,
        Linux Media Mailing List <linux-media@vger.kernel.org>,
        linux-doc@vger.kernel.org
Content-Transfer-Encoding: 8BIT
Message-Id: <0BFF551D-C171-4C84-B131-C38F57A1C67A@darmarit.de>
References: <1472657372-21039-1-git-send-email-markus.heiser@darmarit.de> <1472657372-21039-2-git-send-email-markus.heiser@darmarit.de> <20160906061909.36aa2986@lwn.net>
To: Jonathan Corbet <corbet@lwn.net>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>


Am 06.09.2016 um 14:19 schrieb Jonathan Corbet <corbet@lwn.net>:

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

Ups, yes you are right.

Should I send a new patch .. or could you fix it?

-- Markus --

> 
> (That will fail on 0.x, but we've already stated that we don't support
> below 1.2).
> 
> jon

