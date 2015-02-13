Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb3-smtp-cloud2.xs4all.net ([194.109.24.29]:47823 "EHLO
	lb3-smtp-cloud2.xs4all.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752934AbbBMPdY (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 13 Feb 2015 10:33:24 -0500
Message-ID: <54DE192B.5060402@xs4all.nl>
Date: Fri, 13 Feb 2015 16:32:59 +0100
From: Hans Verkuil <hverkuil@xs4all.nl>
MIME-Version: 1.0
To: Ricardo Ribalda Delgado <ricardo.ribalda@gmail.com>
CC: Pawel Osciak <pawel@osciak.com>,
	Marek Szyprowski <m.szyprowski@samsung.com>,
	Kyungmin Park <kyungmin.park@samsung.com>,
	Mauro Carvalho Chehab <mchehab@osg.samsung.com>,
	linux-media <linux-media@vger.kernel.org>,
	LKML <linux-kernel@vger.kernel.org>,
	Hans Verkuil <hans.verkuil@cisco.com>,
	martin.petersen@oracle.com, hch@lst.de, tonyb@cybernetics.com,
	axboe@fb.com, Stephen Rothwell <sfr@canb.auug.org.au>,
	lauraa@codeaurora.org,
	Benjamin Herrenschmidt <benh@kernel.crashing.org>,
	webbnh@hp.com, hare@suse.de,
	Andrew Morton <akpm@linux-foundation.org>,
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: Re: [PATCH v2 1/3] media/videobuf2-dma-sg: Fix handling of sg_table
 structure
References: <1423650827-16232-1-git-send-email-ricardo.ribalda@gmail.com> <54DE11FA.6050702@xs4all.nl> <CAPybu_0wpNU0m2jjmbff+-mcoU-dkKjpHoW8Hr-GPyWH4oGcgQ@mail.gmail.com>
In-Reply-To: <CAPybu_0wpNU0m2jjmbff+-mcoU-dkKjpHoW8Hr-GPyWH4oGcgQ@mail.gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 02/13/2015 04:20 PM, Ricardo Ribalda Delgado wrote:
> Hello Hans
> 
> On Fri, Feb 13, 2015 at 4:02 PM, Hans Verkuil <hverkuil@xs4all.nl> wrote:
>> Hi Ricardo, Marek,
>>
>> I have a few questions, mostly to improve my own understanding.
>>
>> First of all, is this solving an actual bug for you, or did you just find
>> it while reviewing code? And if it solves a bug, then which architecture
>> are you using? ARM? Intel?
>>
> 
> My arch is intel based (AMD APU). I found it while doing review. While
> updating our kernel to 3.19 I had to patch some of my out of tree
> drivers, and then I gave a look to the file.
> 
>>> dma_map_sg returns the number of areas mapped by the hardware,
>>> which could be different than the areas given as an input.
>>> The output must be saved to nent.
>>>
>>> The output of dma_map, should be used to transverse the scatter list.
>>>
>>> dma_unmap_sg needs the value passed to dma_map_sg (nents_orig).
>>
>> I noticed that few dma_unmap_sg calls actually use orig_nents. It makes
>> me wonder if the dma_unmap_sg documentation is actually correct. It does
>> clearly state that orig_nents should be used, and it might well be that
>> the only reason this hasn't led to problems is that very few architectures
>> actually seem to return nents < orig_nents.

Actually, I think I should pay more attention how often I actually write
'actually'. I went a bit too far with that... :-)

> 
> It is not the most clear API to use :(. Some of the prototypes do not
> make a lot of sense, and it is documented outside the code.
> 
> I have sent these two patches:
> 
> https://lkml.org/lkml/2015/2/11/231
> https://lkml.org/lkml/2015/2/11/232
> 
>>> +     sgt->nents = dma_map_sg_attrs(buf->dev, sgt->sgl, sgt->orig_nents,
>>> +                                   buf->dma_dir, &attrs);
>>
>> Is a driver free to change sgt->nents? It's unclear from the documentation
>> or code that that is actually the purpose of sgt->nents. Most drivers seem
>> to store the result of dma_map_sg into a driver-specific struct.
> 
> As I understand it, this is the purpose of the struct scatter list,
> have at hand the three values that you need,
> the sgl, nents and orig_ents.
> 
> But it would be great if the maintaner of the dma-api speaks up :)

Yes please. And if Ricardo is correct, then someone (janitor job?) should do
a review of dma_unmap_sg in particular.

Regards,

	Hans

> 
> I am putting  get_maintainer.pl in cc
> 
> Thanks Hans!
> 

