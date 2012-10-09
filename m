Return-path: <linux-media-owner@vger.kernel.org>
Received: from ams-iport-4.cisco.com ([144.254.224.147]:28051 "EHLO
	ams-iport-4.cisco.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754551Ab2JIJnS (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Tue, 9 Oct 2012 05:43:18 -0400
From: Hans Verkuil <hverkuil@xs4all.nl>
To: Andrey Smirnov <andrey.smirnov@convergeddevices.net>
Subject: Re: [PATCH v2 3/6] Add commands abstraction layer for SI476X MFD
Date: Tue, 9 Oct 2012 11:42:54 +0200
Cc: mchehab@redhat.com, sameo@linux.intel.com,
	broonie@opensource.wolfsonmicro.com, perex@perex.cz, tiwai@suse.de,
	linux-media@vger.kernel.org, linux-kernel@vger.kernel.org
References: <1349488502-11293-1-git-send-email-andrey.smirnov@convergeddevices.net> <201210081056.51277.hverkuil@xs4all.nl> <50733245.6020406@convergeddevices.net>
In-Reply-To: <50733245.6020406@convergeddevices.net>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Message-Id: <201210091142.54364.hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Mon 8 October 2012 22:06:29 Andrey Smirnov wrote:
> On 10/08/2012 01:56 AM, Hans Verkuil wrote:
> > On Sat October 6 2012 03:54:59 Andrey Smirnov wrote:
> >> This patch adds all the functions used for exchanging commands with
> >> the chip.
> >>
> >> Signed-off-by: Andrey Smirnov <andrey.smirnov@convergeddevices.net>
> >> ---
> >>  drivers/mfd/si476x-cmd.c | 1493 ++++++++++++++++++++++++++++++++++++++++++++++
> >>  1 file changed, 1493 insertions(+)
> >>  create mode 100644 drivers/mfd/si476x-cmd.c
> >>
> >> diff --git a/drivers/mfd/si476x-cmd.c b/drivers/mfd/si476x-cmd.c
> >> new file mode 100644
> >> index 0000000..f11cf58
> >> --- /dev/null
> >> +++ b/drivers/mfd/si476x-cmd.c

<snip>

> >> +/**
> >> + * si476x_cmd_am_rsq_status - send 'FM_TUNE_FREQ' command to the
> >> + * device
> >> + * @core  - device to send the command to
> >> + * @rsqack - if set command clears RSQINT, SNRINT, SNRLINT, RSSIHINT,
> >> + *           RSSSILINT, BLENDINT, MULTHINT and MULTLINT
> >> + * @attune - when set the values in the status report are the values
> >> + *           that were calculated at tune
> >> + * @cancel - abort ongoing seek/tune opertation
> >> + * @stcack - clear the STCINT bin in status register
> >> + * @report - all signal quality information retured by the command
> >> + *           (if NULL then the output of the command is ignored)

I've just noticed that this comment block does not correspond at all to
the code. It's a good idea to check the other comment blocks for similar
copy/paste errors.

> >> + *
> >> + * Function returns 0 on success and negative error code on failure
> >> + */
> >> +int si476x_core_cmd_am_rsq_status(struct si476x_core *core,
> >> +				  struct si476x_rsq_status_args *rsqargs,
> >> +				  struct si476x_rsq_status_report *report)
> >> +{
> >> +	int err;
> >> +	u8       resp[CMD_AM_RSQ_STATUS_NRESP];
> >> +	const u8 args[CMD_AM_RSQ_STATUS_NARGS] = {
> >> +		rsqargs->rsqack << 3 | rsqargs->attune << 2 |
> >> +		rsqargs->cancel << 1 | rsqargs->stcack,
> >> +	};
> >> +
> >> +	err = CORE_SEND_COMMAND(core, CMD_AM_RSQ_STATUS,
> >> +				args, resp,
> >> +				atomic_read(&core->timeouts.command));
> >> +
> >> +	if (report) {
> > Do you really need to test 'report'? Does it ever make sense if this is
> > called with a NULL report pointer?
> 
> Unfortunately yes. This command is also used to acknowledge and
> STC(seek-tune completed)
> interrupt.

A comment would be welcome here, and in similar cases. It's not obvious.

Regards,

	Hans
