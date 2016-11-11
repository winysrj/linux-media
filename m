Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp2-2.goneo.de ([85.220.129.34]:35362 "EHLO smtp2-2.goneo.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1754761AbcKKLpV (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Fri, 11 Nov 2016 06:45:21 -0500
Content-Type: text/plain; charset=us-ascii
Mime-Version: 1.0 (Mac OS X Mail 6.6 \(1510\))
Subject: Re: [Ksummit-discuss] Including images on Sphinx documents
From: Markus Heiser <markus.heiser@darmarit.de>
In-Reply-To: <87pom2clcp.fsf@intel.com>
Date: Fri, 11 Nov 2016 12:45:04 +0100
Cc: ksummit-discuss@lists.linuxfoundation.org,
        linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org,
        Mauro Carvalho Chehab <mchehab@s-opensource.com>,
        linux-media@vger.kernel.org
Content-Transfer-Encoding: 7bit
Message-Id: <4021ED64-7A22-4DDF-A1D4-9DC299F69AE7@darmarit.de>
References: <20161107075524.49d83697@vento.lan> <20161107170133.4jdeuqydthbbchaq@x> <A4091944-D727-45B5-AC24-FE3B2700298E@darmarit.de> <8737j0hpi0.fsf@intel.com> <DC27B5F7-D69E-4F22-B184-B7B029392959@darmarit.de> <87shr0g90r.fsf@intel.com> <a6b88e7d-9d6b-4dcc-3d2e-c09bdf366b40@darmarit.de> <87y40rei5z.fsf@intel.com> <87pom2clcp.fsf@intel.com>
To: Jani Nikula <jani.nikula@linux.intel.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>


Am 11.11.2016 um 12:22 schrieb Jani Nikula <jani.nikula@linux.intel.com>:

> On Thu, 10 Nov 2016, Jani Nikula <jani.nikula@linux.intel.com> wrote:
>> On Thu, 10 Nov 2016, Markus Heiser <markus.heiser@darmarit.de> wrote:
>>> Could this POC persuade you, if so, I send a more elaborate RFC,
>>> what do you think about?
>> 
>> Sorry, I do not wish to be part of this.
> 
> That was uncalled for, apologies.

It's OK, sometimes we are all in a hurry and want shorten things.

> Like I said, I don't think this is the right approach. Call it an
> unsubstantiated gut feel coming from experience.

Yes, building a bunch of symbolic links "smells". Unfortunately,
I currently see no other solution to solve the conflict of 
Linux's "O=/foo" and Sphinx's "sourcedir", so that was my
proposal.

> However, I do not have
> the time to properly dig into this either, and that frustrates me. I
> wish I could be more helpful, but I can't right now.

its a pity

-- Markus --
