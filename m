Return-path: <linux-media-owner@vger.kernel.org>
Received: from ducie-dc1.codethink.co.uk ([185.25.241.215]:55361 "EHLO
	ducie-dc1.codethink.co.uk" rhost-flags-OK-FAIL-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751917AbaDKJfx (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 11 Apr 2014 05:35:53 -0400
Message-ID: <5347B772.1090208@codethink.co.uk>
Date: Fri, 11 Apr 2014 10:35:46 +0100
From: Ben Dooks <ben.dooks@codethink.co.uk>
MIME-Version: 1.0
To: Guennadi Liakhovetski <g.liakhovetski@gmx.de>,
	Bryan Wu <cooloney@gmail.com>
CC: Josh Wu <josh.wu@atmel.com>,
	"linux-media@vger.kernel.org" <linux-media@vger.kernel.org>,
	linux-tegra <linux-tegra@vger.kernel.org>
Subject: Re: [v2] media: soc-camera: OF cameras
References: <1392235552-28134-1-git-send-email-pengw@nvidia.com> <1394794130-13660-1-git-send-email-josh.wu@atmel.com> <CAK5ve-KuPJa6rBdYGvkuPyQU5TCiEe1t=PzEKN4NgsKgVWogqA@mail.gmail.com> <Pine.LNX.4.64.1404102308500.25569@axis700.grange>
In-Reply-To: <Pine.LNX.4.64.1404102308500.25569@axis700.grange>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 10/04/14 22:18, Guennadi Liakhovetski wrote:
> Hi Bryan,
>
> On Tue, 8 Apr 2014, Bryan Wu wrote:
>
>> Thanks Josh, I think I will take you point and rework my patch again.
>> But I need Guennadi's review firstly, Guennadi, could you please help
>> to review it?
>
> Ok, let me double check the situation:
>
> 1. We've got this patch from you, aiming at adding OF probing support to
> soc-camra
>
> 2. We've got an alternative patch from Ben to do the same, his last reply
> to a comment to his patch was "Thanks, I will look into this."
>
> 3. We've got Ben's patches for rcar-vin, that presumably work with his
> patch from (2) above
>
> 4. We've got Josh's patches to add OF / async probing to atmel-isi and
> ov2640, that are not known to work with either (1) or (2) above, so, they
> don't work at all, right?
>
> So, to summarise, there is a core patch from Ben, that he possibly wants
> to adjust, and that works with his rcar-vin OF, there is a patch from you
> that isn't known to work with any driver, and there are patches from Josh,
> that don't work, because there isn't a suitable patch available for them.
> I will have a look at your and Ben's soc-camera OF patches to compare them
> and compare them with my early code (hopefully this coming weekend), but
> so far it looks like only Ben's solution has a complete working stack. Am
> I missing something?

I am looking in to fix the comments from Josh to get the atmel to
work and hope to have them out this weekend.

-- 
Ben Dooks				http://www.codethink.co.uk/
Senior Engineer				Codethink - Providing Genius
