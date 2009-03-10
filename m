Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.gmx.net ([213.165.64.20]:58574 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1752484AbZCJRSp (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Tue, 10 Mar 2009 13:18:45 -0400
Message-ID: <49B6A0EF.6030505@gmx.de>
Date: Tue, 10 Mar 2009 18:18:39 +0100
From: wk <handygewinnspiel@gmx.de>
MIME-Version: 1.0
To: Mauro Carvalho Chehab <mchehab@infradead.org>
CC: Andy Walls <awalls@radix.net>, Hans Verkuil <hverkuil@xs4all.nl>,
	Devin Heitmueller <devin.heitmueller@gmail.com>,
	linux-media@vger.kernel.org
Subject: Re: V4L2 spec
References: <200903061523.15766.hverkuil@xs4all.nl>	<49B59230.1090305@gmx.de>	<412bdbff0903091510n5e000675sfa7b983c9b855123@mail.gmail.com>	<200903092344.04805.hverkuil@xs4all.nl>	<1236642394.3104.25.camel@palomino.walls.org> <20090309215415.6445054d@pedra.chehab.org>
In-Reply-To: <20090309215415.6445054d@pedra.chehab.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Mauro Carvalho Chehab schrieb:
> On Mon, 09 Mar 2009 19:46:34 -0400
> Andy Walls <awalls@radix.net> wrote:
>
>   
>>> and integrating it into the existing v4l docbook,  
>>>       
>> I'm not sure of the value in that.
>>     
>
> The DVB conversion to docbook allows us to add it at the kernel docbook docs
> (probably, not the entire doc, but the parts that describe the internal kernel
> API).
>
>   
>> <opinion>
>> Implmenting something to multiple (or multi-volume) specifications is
>> indeed a pain, but it makes documentation maintenance easier as the task
>> is easily divided along areas of personnel expertise.  Assuming the rate
>> of documentation maintencance does not rapidly increase, keeping
>> documentation maintenace simple is paramount.
>>     
>
> If you take a look on V4L docbooks, it is divided into multiple volume files:
>
> biblio.sgml          pixfmt-nv16.sgml                 vidioc-enumstd.sgml
> common.sgml          pixfmt-packed-rgb.sgml           vidioc-g-audioout.sgml
> compat.sgml          pixfmt-packed-yuv.sgml           vidioc-g-audio.sgml
> controls.sgml        pixfmt-sbggr16.sgml              vidioc-g-crop.sgml
> dev-capture.sgml     pixfmt-sbggr8.sgml               vidioc-g-ctrl.sgml
> dev-codec.sgml       pixfmt-sgbrg8.sgml               vidioc-g-enc-index.sgml
> ...
>
> If we merge DVB there, for sure we should break it into some files, and maybe
> even having they on separate directories.
>
>   
>> Also multiple specifcations (or volumes) clearly group requirements into
>> large chunks of "I don't care about that volume" and "I do care about
>> this volume".  Combining the V4L2 and DVB spec into one volume would
>> probably be a strategic error for some tactical advantage in dealing
>> with hybrid devices.
>>     
>
> This is a good point. 
>
> On my opinion, it seems good to merge the docs. This is just my 2 cents.
>
> If we merge both, IMO, we should break the doc into two parts, being one for
> analog and another for digital, with an introductory text with the hybrid
> devices glue.
>
> If we decide not to merge, we can at least try to follow the same model on both
> documents, and link a common sgml introductory text for hybrid devices to be
> added on both documents.
>
>
>   
>> </opinion>
>>     
>
>
> Cheers,
> Mauro
>
>   
What about a two step aproach for each chapter?

- doing work on *contents* with developers inside linuxtv dvb wiki on 
standard wiki page
- convert wiki text to docbook (textformatting stuff) by someone else.

By doing so, the work load would be split into two independend topics, 
work on contents in wiki and afterwards textformatting of that agreed 
contents without help of developers afterwards and supplying to ML as patch.
If we would do so, one would prepare a wiki page with the actual 
contents of one chapter of the current api and set a deadline for 
editing that page.
Developers should edit contents (easy and fast on wiki) until deadline. 
It would improve greatly the speed of that work.

Keeping the logical structure of the document would also allow to have 
the "I don't care about that volume" feature as well to merge the 
decoder of the FF cards into V4l2 mpeg decoder section.

Introduction
        What you need to know (remove)
        History (as short as possible)
        Overview
        Linux DVB Devices
        API include files
DVB Frontend API (add a lot of missing stuff here.)
        Frontend Data Types
        Frontend Function Calls
DVB Demux Device
        Demux Data Types
        Demux Function Calls
DVB Video Device (merge with v4l2 mpeg decoders)
DVB Audio Device (merge with v4l2 mpeg decoders)
DVB CA Device
        CA Data Types
DVB Network API
        DVB Net Data Types
Kernel Demux API
       Kernel Demux Data Types
       Demux Directory API
        Demux API
        Demux Callback API
        TS Feed API
        Section Feed API
Examples

--Winfried






