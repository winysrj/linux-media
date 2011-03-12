Return-path: <mchehab@pedra>
Received: from mailout-de.gmx.net ([213.165.64.22]:58634 "HELO
	mailout-de.gmx.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1752830Ab1CLAmw (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 11 Mar 2011 19:42:52 -0500
Date: Sat, 12 Mar 2011 01:42:48 +0100
From: Daniel =?iso-8859-1?Q?Gl=F6ckner?= <daniel-gl@gmx.net>
To: "Martin Bugge \(marbugge\)" <marbugge@cisco.com>
Cc: linux-media@vger.kernel.org, Hans Verkuil <hans.verkuil@cisco.com>
Subject: Re: [RFC] HDMI-CEC proposal, ver 2
Message-ID: <20110312004247.GA1397@minime.bse>
References: <4D7A0929.6080705@cisco.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4D7A0929.6080705@cisco.com>
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

Hi Martin,

On Fri, Mar 11, 2011 at 12:36:09PM +0100, Martin Bugge (marbugge) wrote:
> Not every tx status is applicable for all modes, see table 1.
> 
> |-----------------------------------------------------|
> |    Av link Mode     |  CEC  |   1   |   2   |   3   |
> |-----------------------------------------------------|
> |      Status         |       |       |       |       |
> |-----------------------------------------------------|
> |      TX_OK          |   a   |  n/a  |   a   |  n/a  |
> |-----------------------------------------------------|
> |  TX_ARB_LOST        |   a   |  n/a  |   a   |   a   |
> |-----------------------------------------------------|
> | TX_RETRY_TIMEOUT    |   a   |  n/a  |   a   |   a   |
> |-----------------------------------------------------|
> | TX_BROADCAST_REJECT |   a   |  n/a  |   a   |  n/a  |
> |-----------------------------------------------------|

TX_ARB_LOST is applicable to mode 1.
Arbitration loss will also be caused by receivers detecting a bad pulse.

> * AV link mode 1:
>      In mode 1 the frame length is fixed to 21 bits (including the
>      start sequence).
>      Some of these bits (Qty 1 - 6) can be arbitrated by the
>      receiver to signal supported formats/standards.
>      conf:
>          enable: true/false
>          upstream_Qty: QTY bits 1-6
>          downstream_Qty: QTY bits 1-6
>              |------------------------------------------------|
>              | Bits:     | 31 - 7 | 6 | 5 | 4 | 3 | 2 | 1 | 0 |
>              |------------------------------------------------|
>              | Qty bits  |   x    | x | 6 | 5 | 4 | 3 | 2 | 1 |
>              |------------------------------------------------|
>              Qty bits 1-6 mapping (x: not used)

If the Linux system is a video source, it must stop arbitrating those
Qty bits as soon as another video source wants to become active.
As this includes the message where the new source announces itself,
this can't be handled by reconfiguration after reception of the message.

If the Linux system is a video sink, the announcement of a new source
should not affect the Qty bits to arbitrate.

And don't get me startet about systems capable of being a video source
and sink at the same time, capturing their own signal until a new source
becomes active...

> * AV link mode 1:
>      Frame received/transmitted:
>      head:
>          |-------------------------------------------------|
>          | Bits:       | 31 - 4 |  3  |   2  |   1  |  0   |
>          |-------------------------------------------------|
>          | head bits:  |    x   | DIR | /PAS | /NAS | /DES |
>          |-------------------------------------------------|
>      Qty: Quality bits 1 - 16;
>          |---------------------------------------|
>          | Bits:     | 31 - 16 | 15 | 14 - 1 | 0 |
>          |---------------------------------------|
>          | Qty bits  |    x    | 16 | 15 - 2 | 1 |
>          |---------------------------------------|
>          x: not used

Is Qty-1 or Qty-16 the bit sent after /DES?

>      In blocking mode only:
>         tx_status: tx status.
>         tx_status_Qty: which Qty bits 1 - 6 bits was arbitrated
>         during transmit.

It may be interesting to know what other devices did to the /PAS and
/DES bits when they were sent as 1.

> * AV link mode 3: TBD. Chances are that nobody ever used this
>      len: length of message in bits, maximum 96 bits.
>      msg: the raw message received/transmitted. (without the start
>      sequence).
>      tx_status: tx status in blocking mode.

Google turned up this:
http://fmt.cs.utwente.nl/publications/files/111_heerink.pdf
It suggests that at least Philips' variant of AV.link mode 3 - EasyLink -
is even closer to CEC than mode 2.

  Daniel
