Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-ve0-f171.google.com ([209.85.128.171]:48942 "EHLO
	mail-ve0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754590Ab3BFOuU (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Wed, 6 Feb 2013 09:50:20 -0500
MIME-Version: 1.0
In-Reply-To: <51123A5F.9050604@ti.com>
References: <1990856.qS9uisuiVF@avalon>
	<51123A5F.9050604@ti.com>
Date: Wed, 6 Feb 2013 09:44:34 -0500
Message-ID: <CADnq5_P1GFbAwoe9kTeARq8ZLP1tOBc9Rn1h2KrRYxkoLxLXfw@mail.gmail.com>
Subject: Re: CDF meeting @FOSDEM report
From: Alex Deucher <alexdeucher@gmail.com>
To: Tomi Valkeinen <tomi.valkeinen@ti.com>
Cc: Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
	linux-fbdev@vger.kernel.org, Sebastien Guiriec <s-guiriec@ti.com>,
	dri-devel@lists.freedesktop.org,
	Jesse Barnes <jesse.barnes@intel.com>,
	Benjamin Gaignard <benjamin.gaignard@linaro.org>,
	Sumit Semwal <sumit.semwal@linaro.org>,
	Tom Gall <tom.gall@linaro.org>,
	Kyungmin Park <kyungmin.park@samsung.com>,
	linux-media@vger.kernel.org,
	Stephen Warren <swarren@wwwdotorg.org>,
	Thierry Reding <thierry.reding@avionic-desi.gn.de>,
	Mark Zhang <markz@nvidia.com>, linaro-mm-sig@lists.linaro.org,
	=?ISO-8859-1?Q?St=E9phane_Marchesin?=
	<stephane.marchesin@gmail.com>,
	Alexandre Courbot <acourbot@nvidia.com>,
	Ragesh Radhakrishnan <Ragesh.R@linaro.org>,
	Thomas Petazzoni <thomas.petazzoni@free-electrons.com>,
	Sunil Joshi <joshi@samsung.com>,
	Maxime Ripard <maxime.ripard@free-electrons.com>,
	Vikas Sajjan <vikas.sajjan@linaro.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Wed, Feb 6, 2013 at 6:11 AM, Tomi Valkeinen <tomi.valkeinen@ti.com> wrote:
> Hi,
>
> On 2013-02-06 00:27, Laurent Pinchart wrote:
>> Hello,
>>
>> We've hosted a CDF meeting at the FOSDEM on Sunday morning. Here's a summary
>> of the discussions.
>
> Thanks for the summary. I've been on a longish leave, and just got back,
> so I haven't read the recent CDF discussions on lists yet. I thought
> I'll start by replying to this summary first =).
>
>> 0. Abbreviations
>> ----------------
>>
>> DBI - Display Bus Interface, a parallel video control and data bus that
>> transmits data using parallel data, read/write, chip select and address
>> signals, similarly to 8051-style microcontroller parallel busses. This is a
>> mixed video control and data bus.
>>
>> DPI - Display Pixel Interface, a parallel video data bus that transmits data
>> using parallel data, h/v sync and clock signals. This is a video data bus
>> only.
>>
>> DSI - Display Serial Interface, a serial video control and data bus that
>> transmits data using one or more differential serial lines. This is a mixed
>> video control and data bus.
>
> In case you'll re-use these abbrevs in later posts, I think it would be
> good to mention that DPI is a one-way bus, whereas DBI and DSI are
> two-way (perhaps that's implicit with control bus, though).
>
>> 1. Goals
>> --------
>>
>> The meeting started with a brief discussion about the CDF goals.
>>
>> Tomi Valkeinin and Tomasz Figa have sent RFC patches to show their views of
>> what CDF could/should be. Many others have provided very valuable feedback.
>> Given the early development stage propositions were sometimes contradictory,
>> and focused on different areas of interest. We have thus started the meeting
>> with a discussion about what CDF should try to achieve, and what it shouldn't.
>>
>> CDF has two main purposes. The original goal was to support display panels in
>> a platform- and subsystem-independent way. While mostly useful for embedded
>> systems, the emergence of platforms such as Intel Medfield and ARM-based PCs
>> that blends the embedded and PC worlds makes panel support useful for the PC
>> world as well.
>>
>> The second purpose is to provide a cross-subsystem interface to support video
>> encoders. The idea originally came from a generalisation of the original RFC
>> that supported panels only. While encoder support is considered as lower
>> priority than display panel support by developers focussed on display
>> controller driver (Intel, Renesas, ST Ericsson, TI), companies that produce
>> video encoders (Analog Devices, and likely others) don't share that point of
>> view and would like to provide a single encoder driver that can be used in
>> both KMS and V4L2 drivers.
>
> What is an encoder? Something that takes a video signal in, and lets the
> CPU store the received data to memory? Isn't that a decoder?
>
> Or do you mean something that takes a video signal in, and outputs a
> video signal in another format? (transcoder?)

In KMS parlance, we have two objects a crtc and an encoder.  A crtc
reads data from memory and produces a data stream with display timing.
 The encoder then takes that datastream and timing from the crtc and
converts it some sort of physical signal (LVDS, TMDS, DP, etc.).  It's
not always a perfect match to the hardware.  For example a lot of GPUs
have a DVO encoder which feeds a secondary encoder like an sil164 DVO
to TMDS encoder.

Alex
