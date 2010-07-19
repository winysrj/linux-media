Return-path: <linux-media-owner@vger.kernel.org>
Received: from shell0.rawbw.com ([198.144.192.45]:58369 "EHLO shell0.rawbw.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751760Ab0GSQxu (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Mon, 19 Jul 2010 12:53:50 -0400
Message-ID: <4C448311.6090704@rawbw.com>
Date: Mon, 19 Jul 2010 09:53:37 -0700
From: Yuri <yuri@rawbw.com>
MIME-Version: 1.0
To: Hans de Goede <hdegoede@redhat.com>
CC: linux-media@vger.kernel.org
Subject: Re: Bugreport for libv4l: error out on webcam: error parsing JPEG
 header: Bogus jpeg format
References: <4C3F61BD.7000001@rawbw.com> <4C444388.9040901@redhat.com>
In-Reply-To: <4C444388.9040901@redhat.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 07/19/2010 05:22, Hans de Goede wrote:
> This is not really a bug in libv4l, but more of a problem with error
> tolerance in the application you are using. However many apps don't 
> handle
> any kind of errors all that well. So the latest libv4l will retry (get 
> a new
> frame) jpeg decompression errors a number of times.

You are right, application is quite rough and doesn't have any tolerance.

But why such bad bytes appear in the first place? I think they are sent 
by the
camera deliberately to indicate something and Windows driver must be knowing
what do they mean. But libv4l just can't interpret them correctly.

Yuri
