Return-path: <linux-media-owner@vger.kernel.org>
Received: from osg.samsung.com ([64.30.133.232]:62616 "EHLO osg.samsung.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751714AbeCUPp7 (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Wed, 21 Mar 2018 11:45:59 -0400
Date: Wed, 21 Mar 2018 12:45:52 -0300
From: Mauro Carvalho Chehab <mchehab@s-opensource.com>
To: Hans Verkuil <hverkuil@xs4all.nl>
Cc: linux-media@vger.kernel.org, Wolfram Sang <wsa@the-dreams.de>,
        Maxime Ripard <maxime.ripard@bootlin.com>,
        dri-devel@lists.freedesktop.org,
        Hans Verkuil <hans.verkuil@cisco.com>
Subject: Re: [PATCHv2 6/7] cec-pin-error-inj.rst: document CEC Pin Error
 Injection
Message-ID: <20180321124511.7e841256@vento.lan>
In-Reply-To: <20180305135139.95652-7-hverkuil@xs4all.nl>
References: <20180305135139.95652-1-hverkuil@xs4all.nl>
        <20180305135139.95652-7-hverkuil@xs4all.nl>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Em Mon,  5 Mar 2018 14:51:38 +0100
Hans Verkuil <hverkuil@xs4all.nl> escreveu:

> From: Hans Verkuil <hans.verkuil@cisco.com>
> 
> The CEC Pin framework adds support for Error Injection.
> 
> Document all the error injections commands and how to use it.

Please notice that all debugfs/sysfs entries should *also* be
documented at the standard way, e. g. by adding the corresponding
documentation at Documentation/ABI.

Please see Documentation/ABI/README.

Additionally, there are a few minor nitpicks on this patch.
See below.

The remaining patches looked ok on my eyes.

I'll wait for a v3 with the debugfs ABI documentation in order to merge
it. Feel free to put it on a separate patch.

Regards,
Mauro

> 
> Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
> ---
>  .../media/cec-drivers/cec-pin-error-inj.rst        | 322 +++++++++++++++++++++
>  Documentation/media/cec-drivers/index.rst          |   1 +
>  MAINTAINERS                                        |   1 +
>  3 files changed, 324 insertions(+)
>  create mode 100644 Documentation/media/cec-drivers/cec-pin-error-inj.rst
> 
> diff --git a/Documentation/media/cec-drivers/cec-pin-error-inj.rst b/Documentation/media/cec-drivers/cec-pin-error-inj.rst
> new file mode 100644
> index 000000000000..21bda831d3fb
> --- /dev/null
> +++ b/Documentation/media/cec-drivers/cec-pin-error-inj.rst
> @@ -0,0 +1,322 @@
> +CEC Pin Framework Error Injection
> +=================================
> +
> +The CEC Pin Framework is a core CEC framework for CEC hardware that only
> +has low-level support for the CEC bus. Most hardware today will have
> +high-level CEC support where the hardware deals with driving the CEC bus,
> +but some older devices aren't that fancy. However, this framework also
> +allows you to connect the CEC pin to a GPIO on e.g. a Raspberry Pi and
> +you can become an instant CEC adapter.
> +
> +What makes doing this so interesting is that since we have full control
> +over the bus it is easy to support error injection. This is ideal to
> +test how well CEC adapters can handle error conditions.
> +
> +Currently only the cec-gpio driver (when the CEC line is directly
> +connected to a pull-up GPIO line) and the AllWinner A10/A20 drm driver
> +support this framework.
> +
> +If ``CONFIG_CEC_PIN_ERROR_INJ`` is enabled, then error injection is available
> +through debugfs. Specifically, in ``/sys/kernel/debug/cec/cecX/`` there is
> +now an ``error-inj`` file.
> +
> +With ``cat error-inj`` you can see both the possible commands and the current
> +error injection status:
> +
> +.. code-block:: none

It is usually better to use "::" instead of ".. code-block".

> +
> +	$ cat /sys/kernel/debug/cec/cec0/error-inj
> +	# Clear error injections:
> +	#   clear          clear all rx and tx error injections
> +	#   rx-clear       clear all rx error injections
> +	#   tx-clear       clear all tx error injections
> +	#   <op> clear     clear all rx and tx error injections for <op>
> +	#   <op> rx-clear  clear all rx error injections for <op>
> +	#   <op> tx-clear  clear all tx error injections for <op>
> +	#
> +	# RX error injection:
> +	#   <op>[,<mode>] rx-nack              NACK the message instead of sending an ACK
> +	#   <op>[,<mode>] rx-low-drive <bit>   force a low-drive condition at this bit position
> +	#   <op>[,<mode>] rx-add-byte          add a spurious byte to the received CEC message
> +	#   <op>[,<mode>] rx-remove-byte       remove the last byte from the received CEC message
> +	#   <op>[,<mode>] rx-arb-lost <poll>   generate a POLL message to trigger an arbitration lost
> +	#
> +	# TX error injection settings:
> +	#   tx-ignore-nack-until-eom           ignore early NACKs until EOM
> +	#   tx-custom-low-usecs <usecs>        define the 'low' time for the custom pulse
> +	#   tx-custom-high-usecs <usecs>       define the 'high' time for the custom pulse
> +	#   tx-custom-pulse                    transmit the custom pulse once the bus is idle
> +	#
> +	# TX error injection:
> +	#   <op>[,<mode>] tx-no-eom            don't set the EOM bit
> +	#   <op>[,<mode>] tx-early-eom         set the EOM bit one byte too soon
> +	#   <op>[,<mode>] tx-add-bytes <num>   append <num> (1-255) spurious bytes to the message
> +	#   <op>[,<mode>] tx-remove-byte       drop the last byte from the message
> +	#   <op>[,<mode>] tx-short-bit <bit>   make this bit shorter than allowed
> +	#   <op>[,<mode>] tx-long-bit <bit>    make this bit longer than allowed
> +	#   <op>[,<mode>] tx-custom-bit <bit>  send the custom pulse instead of this bit
> +	#   <op>[,<mode>] tx-short-start       send a start pulse that's too short
> +	#   <op>[,<mode>] tx-long-start        send a start pulse that's too long
> +	#   <op>[,<mode>] tx-custom-start      send the custom pulse instead of the start pulse
> +	#   <op>[,<mode>] tx-last-bit <bit>    stop sending after this bit
> +	#   <op>[,<mode>] tx-low-drive <bit>   force a low-drive condition at this bit position
> +	#
> +	# <op>       CEC message opcode (0-255) or 'any'
> +	# <mode>     'once' (default), 'always', 'toggle' or 'off'
> +	# <bit>      CEC message bit (0-159)
> +	#            10 bits per 'byte': bits 0-7: data, bit 8: EOM, bit 9: ACK
> +	# <poll>     CEC poll message used to test arbitration lost (0x00-0xff, default 0x0f)
> +	# <usecs>    microseconds (0-10000000, default 1000)
> +
> +	clear
> +
> +You can write error injection commands to ``error-inj`` using ``echo 'cmd' >error-inj``
> +or ``cat cmd.txt >error-inj``. The ``cat error-inj`` output contains the current
> +error commands. You can save the output to a file and use it as an input to
> +``error-inj`` later.

Please word-wrap it to fit into 80 columns (actually, it is better to use
something lower than that, like 72, as it makes easier to do small
adjustments without needing to change an entire text block.

(Same applies to other parts of this patch)



Thanks,
Mauro
