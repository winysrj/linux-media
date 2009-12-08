Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:64134 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754687AbZLHNWw (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Tue, 8 Dec 2009 08:22:52 -0500
Message-ID: <4B1E532C.9040903@redhat.com>
Date: Tue, 08 Dec 2009 11:22:52 -0200
From: Mauro Carvalho Chehab <mchehab@redhat.com>
MIME-Version: 1.0
To: Julian Scheel <julian@jusst.de>
CC: linux-media@vger.kernel.org
Subject: Re: New DVB-Statistics API
References: <4B1E1974.6000207@jusst.de>
In-Reply-To: <4B1E1974.6000207@jusst.de>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Julian,

Let me add some corrections to your technical analysis.

Julian Scheel wrote:
> Hello together,
> 
> after the last thread which asked about signal statistics details
> degenerated into a discussion about the technical possibilites for
> implementing an entirely new API, which lead to nothing so far, I wanted
> to open a new thread to bring this forward. Maybe some more people can
> give their votes for the different options
> 
> Actually Manu did propose a new API for fetching enhanced statistics. It
> uses new IOCTL to directly fetch the statistical data in one go from the
> frontend. This propose was so far rejected by Mauro who wants to use the
> S2API get/set calls instead.
> 
> Now to give everyone a quick overview about the advantages and
> disadvantages of both approaches I will try to summarize it up:
> 
> 1st approach: Introduce new IOCTL
> 
> Pros:
> - Allows a quick fetch of the entire dataset, which ensures that:
>  1. all values are fetched in one go (as long as possible) from the
> frontend, so that they can be treated as one united and be valued in
> conjunction
>  2. the requested values arrive the caller in an almost constant
> timeframe, as the ioctl is directly executed by the driver
> - It does not interfere with the existing statistics API, which has to
> be kept alive as it is in use for a long time already. (unifying it's
> data is not the approach of this new API)
> 
> Cons:
> - Forces the application developers to interact with two APIs. The S2API
> for tuning on the one hand and the Statistics API for reading signal
> values on the other hand.
> 
> 2nd approach: Set up S2API calls for reading statistics
> 
> Pros:
> - Continous unification of the linuxtv API, allowing all calls to be
> made through one API. -> easy for application developers

- Scaling values can be retrieved/negotiated (if we implement the set
mode) before requesting the stats, using the same API;

- API can be easily extended to support other statistics that may be needed
by newer DTV standards.

> 
> Cons:
> - Due to the key/value pairs used for S2API getters the statistical
> values can't be read as a unique block, so we loose the guarantee, that
> all of the values can be treatend as one unit expressing the signals
> state at a concrete time.

You missed the point here. The proposal patch groups all S2API
pairs into a _single_ call into the driver:

> +		for (i = 0; i < tvps->num; i++)
> +			need_get_ops += dtv_property_prepare_get_stats(fe,
> +							 tvp + i, inode, file);
> +
> +		if (!fe->dtv_property_cache.need_stats) {
> +			need_get_ops++;
> +		} else {
> +			if (fe->ops.get_stats) {
> +				err = fe->ops.get_stats(fe);
> +				if (err < 0)
> +					return err;
> +			}
> +		}

The dtv_property_prepare_get_stats will generate a bitmap field (need_stats) that
will describe all value pairs that userspace is expecting. After doing it,
a single call is done to get_stats() callback.

All the driver need to do is to fill all values at dtv_property_cache. If the driver
fills more values than requested by the user, the extra values will simply be discarded.

In order to reduce latency, the driver may opt to not read the register values for the
data that aren't requested by the user, like I did on cx24123 driver.

Those values will all be returned at the same time to userspace by a single copy_to_user()
operation.

> - Due to the general architecture of the S2API the delay between
> requesting and receiving the actual data could become too big to allow
> realtime interpretation of the data (as it is needed for applications
> like satellite finders, etc.)

Not true. As pointed at the previous answer, the difference between a new ioctl
and S2API is basically the code at dtv_property_prepare_get_stats() and
dtv_property_process_get(). This is a pure code that uses a continuous struct
that will likely be at L3 cache, inside the CPU chip. So, this code will run
really quickly.

As current CPU's runs at the order of Teraflops (as the CPU clocks are at gigahertz
order, and CPU's can handle multiple instructions per clock cycle), the added delay
is in de order of nanosseconds. 

On the other hand, a simple read of a value from an i2c device is in the order
of milisseconds, since I2C serial bus, speed is slow (typically operating at
100 Kbps).

So, the delay is determined by the number of I2C calls you have at the code.

With the new ioctl proposal, as you need to read all data from I2C (even the ones
that userspace don't need), you'll have two situations:
	- if you use S2API call to request all data provided by ioctl approach,
the delay will be the same;
	- if you use S2API call to request less stats, the S2API delay will
be shorter. 

For example, with cx24123, the S2API delay it will be 6 times shorter than the
ioctl, if you request just the signal strength - as just one read is needed
to get signal strength, while you need to do 6 reads to get all 3 stats.

So, if you want to do some realtime usage and delay is determinant, a call
via S2API containing just the values you need will be better than the new
ioctl call.

The only cons I can think is that the S2API payload for a complete retrival of all
stats will be a little bigger.


Cheers,
Mauro.
