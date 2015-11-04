Return-path: <linux-media-owner@vger.kernel.org>
Received: from lists.s-osg.org ([54.187.51.154]:60870 "EHLO lists.s-osg.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751522AbbKDNJF (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Wed, 4 Nov 2015 08:09:05 -0500
Date: Wed, 4 Nov 2015 11:08:58 -0200
From: Mauro Carvalho Chehab <mchehab@osg.samsung.com>
To: Linux Media Mailing List <linux-media@vger.kernel.org>
Cc: Jonathan Corbet <corbet@lwn.net>,
	Thierry Reding <thierry.reding@gmail.com>,
	linux-doc@vger.kernel.org
Subject: Re: [PATCH] demux.h: move documentation overview from
 device-drivers.tmpl
Message-ID: <20151104110858.7f0b8cc9@recife.lan>
In-Reply-To: <b8cc97e8a7c4761f6113b289205ebf11f0c9933f.1446642341.git.mchehab@osg.samsung.com>
References: <b8cc97e8a7c4761f6113b289205ebf11f0c9933f.1446642341.git.mchehab@osg.samsung.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Em Wed, 04 Nov 2015 11:07:09 -0200
Mauro Carvalho Chehab <mchehab@osg.samsung.com> escreveu:

> It is better to keep the documentation overview at the header file,
> as this makes easier for developers to remember to fix when needed.
> 
> Signed-off-by: Mauro Carvalho Chehab <mchehab@osg.samsung.com>

I forgot to add:
Suggested-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>


> 
> ---
> 
> As suggested during the KS Workshop, the best is to use the !P meta-tag , and keep
> the documentation overview at the header file.
> 
> diff --git a/Documentation/DocBook/device-drivers.tmpl b/Documentation/DocBook/device-drivers.tmpl
> index 42a2d8593e39..c2bc8f779a9b 100644
> --- a/Documentation/DocBook/device-drivers.tmpl
> +++ b/Documentation/DocBook/device-drivers.tmpl
> @@ -243,71 +243,12 @@ X!Isound/sound_firmware.c
>  !Idrivers/media/dvb-core/dvb_math.h
>  !Idrivers/media/dvb-core/dvb_ringbuffer.h
>  !Idrivers/media/dvb-core/dvbdev.h
> -	<sect1><title>Digital TV Demux API</title>
> -	    <para>The kernel demux API defines a driver-internal interface for
> -	    registering low-level, hardware specific driver to a hardware
> -	    independent demux layer. It is only of interest for Digital TV
> -	    device driver writers. The header file for this API is named
> -	    <constant>demux.h</constant> and located in
> -	    <constant>drivers/media/dvb-core</constant>.</para>
> -
> -	<para>The demux API should be implemented for each demux in the
> -	system. It is used to select the TS source of a demux and to manage
> -	the demux resources. When the demux client allocates a resource via
> -	the demux API, it receives a pointer to the API of that
> -	resource.</para>
> -	<para>Each demux receives its TS input from a DVB front-end or from
> -	memory, as set via this demux API. In a system with more than one
> -	front-end, the API can be used to select one of the DVB front-ends
> -	as a TS source for a demux, unless this is fixed in the HW platform.
> -	The demux API only controls front-ends regarding to their connections
> -	with demuxes; the APIs used to set the other front-end parameters,
> -	such as tuning, are not defined in this document.</para>
> -	<para>The functions that implement the abstract interface demux should
> -	be defined static or module private and registered to the Demux
> -	core for external access. It is not necessary to implement every
> -	function in the struct <constant>dmx_demux</constant>. For example,
> -	a demux interface might support Section filtering, but not PES
> -	filtering. The API client is expected to check the value of any
> -	function pointer before calling the function: the value of NULL means
> -	that the &#8220;function is not available&#8221;.</para>
> -	<para>Whenever the functions of the demux API modify shared data,
> -	the possibilities of lost update and race condition problems should
> -	be addressed, e.g. by protecting parts of code with mutexes.</para>
> -	<para>Note that functions called from a bottom half context must not
> -	sleep. Even a simple memory allocation without using GFP_ATOMIC can
> -	result in a kernel thread being put to sleep if swapping is needed.
> -	For example, the Linux kernel calls the functions of a network device
> -	interface from a bottom half context. Thus, if a demux API function
> -	is called from network device code, the function must not sleep.
> -	</para>
> -    </sect1>
> -
> -    <section id="demux_callback_api">
> -	<title>Demux Callback API</title>
> -	<para>This kernel-space API comprises the callback functions that
> -	deliver filtered data to the demux client. Unlike the other DVB
> -	kABIs, these functions are provided by the client and called from
> -	the demux code.</para>
> -	<para>The function pointers of this abstract interface are not
> -	packed into a structure as in the other demux APIs, because the
> -	callback functions are registered and used independent of each
> -	other. As an example, it is possible for the API client to provide
> -	several callback functions for receiving TS packets and no
> -	callbacks for PES packets or sections.</para>
> -	<para>The functions that implement the callback API need not be
> -	re-entrant: when a demux driver calls one of these functions,
> -	the driver is not allowed to call the function again before
> -	the original call returns. If a callback is triggered by a
> -	hardware interrupt, it is recommended to use the Linux
> -	&#8220;bottom half&#8221; mechanism or start a tasklet instead of
> -	making the callback function call directly from a hardware
> -	interrupt.</para>
> -	<para>This mechanism is implemented by
> -	<link linkend='API-dmx-ts-cb'>dmx_ts_cb()</link> and
> -	<link linkend='API-dmx-section-cb'>dmx_section_cb()</link>.</para>
> -    </section>
> -
> +     <sect1><title>Digital TV Demux API</title>
> +!Pdrivers/media/dvb-core/demux.h Digital TV Demux API
> +     </sect1>
> +     <sect1><title>Demux Callback API</title>
> +!Pdrivers/media/dvb-core/demux.h Demux Callback API
> +     </sect1>
>  !Idrivers/media/dvb-core/demux.h
>      </sect1>
>      <sect1><title>Remote Controller devices</title>
> diff --git a/drivers/media/dvb-core/demux.h b/drivers/media/dvb-core/demux.h
> index ccc1f43cb9a9..f8014aabf37b 100644
> --- a/drivers/media/dvb-core/demux.h
> +++ b/drivers/media/dvb-core/demux.h
> @@ -32,6 +32,49 @@
>  #include <linux/time.h>
>  #include <linux/dvb/dmx.h>
>  
> +/**
> + * DOC: Digital TV Demux API
> + *
> + * The kernel demux API defines a driver-internal interface for registering
> + * low-level, hardware specific driver to a hardware independent demux layer.
> + * It is only of interest for Digital TV device driver writers.
> + * The header file for this API is named demux.h and located in
> + * drivers/media/dvb-core.
> + *
> + * The demux API should be implemented for each demux in the system. It is
> + * used to select the TS source of a demux and to manage the demux resources.
> + * When the demux client allocates a resource via the demux API, it receives
> + * a pointer to the API of that	resource.
> + *
> + * Each demux receives its TS input from a DVB front-end or from memory, as
> + * set via this demux API. In a system with more than one front-end, the API
> + * can be used to select one of the DVB front-ends as a TS source for a demux,
> + * unless this is fixed in the HW platform.
> + *
> + * The demux API only controls front-ends regarding to their connections with
> + * demuxes; the APIs used to set the other front-end parameters, such as
> + * tuning, are not defined in this document.
> + *
> + * The functions that implement the abstract interface demux should be defined
> + * static or module private and registered to the Demux core for external
> + * access. It is not necessary to implement every function in the struct
> + * &dmx_demux. For example, a demux interface might support Section filtering,
> + * but not PES filtering. The API client is expected to check the value of any
> + * function pointer before calling the function: the value of NULL means
> + * that the function is not available.
> + *
> + * Whenever the functions of the demux API modify shared data, the
> + * possibilities of lost update and race condition problems should be
> + * addressed, e.g. by protecting parts of code with mutexes.
> + *
> + * Note that functions called from a bottom half context must not sleep.
> + * Even a simple memory allocation without using %GFP_ATOMIC can result in a
> + * kernel thread being put to sleep if swapping is needed. For example, the
> + * Linux Kernel calls the functions of a network device interface from a
> + * bottom half context. Thus, if a demux API function is called from network
> + * device code, the function must not sleep.
> + */
> +
>  /*
>   * Common definitions
>   */
> @@ -187,8 +230,28 @@ struct dmx_section_feed {
>  	int (*stop_filtering)(struct dmx_section_feed *feed);
>  };
>  
> -/*
> - * Callback functions
> +/**
> + * DOC: Demux Callback API
> + *
> + * This kernel-space API comprises the callback functions that deliver filtered
> + * data to the demux client. Unlike the other DVB kABIs, these functions are
> + * provided by the client and called from the demux code.
> + *
> + * The function pointers of this abstract interface are not packed into a
> + * structure as in the other demux APIs, because the callback functions are
> + * registered and used independent of each other. As an example, it is possible
> + * for the API client to provide several callback functions for receiving TS
> + * packets and no callbacks for PES packets or sections.
> + *
> + * The functions that implement the callback API need not be re-entrant: when
> + * a demux driver calls one of these functions, the driver is not allowed to
> + * call the function again before the original call returns. If a callback is
> + * triggered by a hardware interrupt, it is recommended to use the Linux
> + * bottom half mechanism or start a tasklet instead of making the callback
> + * function call directly from a hardware interrupt.
> + *
> + * This mechanism is implemented by dmx_ts_cb() and dmx_section_cb()
> + * callbacks.
>   */
>  
>  /**
