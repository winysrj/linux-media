Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp3-1.goneo.de ([85.220.129.38]:48181 "EHLO smtp3-1.goneo.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751119AbcGTFfv convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 20 Jul 2016 01:35:51 -0400
Content-Type: text/plain; charset=us-ascii
Mime-Version: 1.0 (Mac OS X Mail 6.6 \(1510\))
Subject: Re: Troubles with kernel-doc and RST files
From: Markus Heiser <markus.heiser@darmarit.de>
In-Reply-To: <20160719210942.3ecf2697@recife.lan>
Date: Wed, 20 Jul 2016 07:35:39 +0200
Cc: Jonathan Corbet <corbet@lwn.net>,
	Linux Media Mailing List <linux-media@vger.kernel.org>,
	Mauro Carvalho Chehab <mchehab@infradead.org>,
	linux-doc@vger.kernel.org, Jani Nikula <jani.nikula@intel.com>
Content-Transfer-Encoding: 8BIT
Message-Id: <C27C1531-FD97-40D5-A712-360283A12728@darmarit.de>
References: <20160717100154.64823d99@recife.lan> <20160719171635.56d16034@lwn.net> <20160719210942.3ecf2697@recife.lan>
To: Mauro Carvalho Chehab <mchehab@s-opensource.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>


Am 20.07.2016 um 02:09 schrieb Mauro Carvalho Chehab <mchehab@s-opensource.com>:

> Em Tue, 19 Jul 2016 17:16:35 -0600
> Jonathan Corbet <corbet@lwn.net> escreveu:
> 
>> On Sun, 17 Jul 2016 10:01:54 -0300
>> Mauro Carvalho Chehab <mchehab@s-opensource.com> wrote:
>> 
>>> 3) When there's an asterisk inside the source code, for example, to
>>> document a pointer, or when something else fails when parsing a
>>> header file, kernel-doc handler just outputs:
>>> 	/devel/v4l/patchwork/Documentation/media/kapi/mc-core.rst:137: WARNING: Inline emphasis start-string without end-string.
>>> 	/devel/v4l/patchwork/Documentation/media/kapi/mc-core.rst:470: WARNING: Explicit markup ends without a blank line; unexpected unindent.
>>> 
>>> pointing to a fake line at the rst file, instead of pointing to the
>>> line inside the parsed header where the issue was detected, making
>>> really hard to identify what's the error.
>>> 
>>> In this specific case, mc-core.rst has only 260 lines at the time I got
>>> such error.  
>> 
>> This sounds like the same warning issue that Daniel was dealing with.
>> Hopefully his config change will at least make these easier to deal with.
>> 
>> I wonder, though, if we could make kernel-doc a little smarter about
>> these things so that the Right Thing happens for this sort of inadvertent
>> markup?  If we could just recognize and escape a singleton *, that would
>> make a lot of things work.
> 
> Yeah, that would be the best, but still, if some error happens, we need
> the real line were it occurred, as it doesn't make sense to point to
> a line that doesn't exist.

I'am not sure, but this might be due to the ".. kernel-doc::" directive.
Give me some time to dig.

-- Markus --

> 
> 
> Thanks,
> Mauro

