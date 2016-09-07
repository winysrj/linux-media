Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp1.goneo.de ([85.220.129.30]:47080 "EHLO smtp1.goneo.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752420AbcIGF0j (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Wed, 7 Sep 2016 01:26:39 -0400
Content-Type: text/plain; charset=us-ascii
Mime-Version: 1.0 (Mac OS X Mail 6.6 \(1510\))
Subject: Re: [PATCH 2/3] doc-rst:c-domain: function-like macros arguments
From: Markus Heiser <markus.heiser@darmarit.de>
In-Reply-To: <20160906062723.5125b89b@lwn.net>
Date: Wed, 7 Sep 2016 07:26:27 +0200
Cc: Mauro Carvalho Chehab <mchehab@infradead.org>,
        Jani Nikula <jani.nikula@intel.com>,
        Linux Media Mailing List <linux-media@vger.kernel.org>,
        linux-doc@vger.kernel.org
Content-Transfer-Encoding: 8BIT
Message-Id: <DD0DE746-C3A0-4863-A199-B9A7944F4CE4@darmarit.de>
References: <1472657372-21039-1-git-send-email-markus.heiser@darmarit.de> <1472657372-21039-3-git-send-email-markus.heiser@darmarit.de> <20160906062723.5125b89b@lwn.net>
To: Jonathan Corbet <corbet@lwn.net>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>


Am 06.09.2016 um 14:27 schrieb Jonathan Corbet <corbet@lwn.net>:

> So I'm going into total nit-picking territory here, but since I'm looking
> at it and I think the series needs a respin anyway...
> 
> On Wed, 31 Aug 2016 17:29:31 +0200
> Markus Heiser <markus.heiser@darmarit.de> wrote:
> 
>> +        m = c_funcptr_sig_re.match(sig)
>> +        if m is None:
>> +            m = c_sig_re.match(sig)
>> +        if m is None:
>> +            raise ValueError('no match')
> 
> How about we put that second test inside the first if block and avoid the
> redundant None test if the first match works?  The energy saved may
> prevent a hurricane someday :)

And prohibit the MS-Windows update installer will save the climate ;)
It is a habit of mine to avoid indentations, but you are right,
it is not appropriate here.

>> +
>> +        rettype, fullname, arglist, _const = m.groups()
>> +        if rettype or not arglist.strip():
>> +            return False
>> +
>> +        arglist = arglist.replace('`', '').replace('\\ ', '').strip()  # remove markup
>> +        arglist = [a.strip() for a in arglist.split(",")]
> 
> Similarly, stripping the args three times seems a bit much.  The middle
> one is totally redundant and could go at a minimum.

Thanks for pointing this. You are right, I will fix it.

-- Markus --

> 
> Thanks,
> 
> jon

