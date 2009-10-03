Return-path: <linux-media-owner@vger.kernel.org>
Received: from proxy3.bredband.net ([195.54.101.73]:56980 "EHLO
	proxy3.bredband.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752353AbZJCQWL (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Sat, 3 Oct 2009 12:22:11 -0400
Received: from iph2.telenor.se (195.54.127.133) by proxy3.bredband.net (7.3.140.3)
        id 49F597CD03F509E1 for linux-media@vger.kernel.org; Sat, 3 Oct 2009 18:21:33 +0200
Message-ID: <2467404e44c3d9bb80ee8973ed2872a0.squirrel@mail.kurelid.se>
In-Reply-To: <tkrat.2a34f4bd39830bed@s5r6.in-berlin.de>
References: <000a01ca431e$14250210$6301a8c0@ds.mot.com>
    <tkrat.2a34f4bd39830bed@s5r6.in-berlin.de>
Date: Sat, 3 Oct 2009 18:21:31 +0200
Subject: Re: [PATCH resend] firedtv: length field corrupt in ca2host if
 length>127
From: "Henrik Kurelid" <henke@kurelid.se>
To: "Stefan Richter" <stefanr@s5r6.in-berlin.de>
Cc: "Henrik Kurelid" <henke@kurelid.se>,
	"Mauro Carvalho Chehab" <mchehab@infradead.org>,
	linux-media@vger.kernel.org
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi,

Comments inline.

Regards,
Henrik

> From: Henrik Kurelid <henke@kurelid.se>
>
> This solves a problem in firedtv that has become major for Swedish DVB-T
> users the last month or so.  It will most likely solve issues seen by
> other users as well.
>
> If the length of an AVC message is greater than 127, the length field
> should be encoded in LV mode instead of V mode. V mode can only be used
> if the length is 127 or less. This patch ensures that the CA_PMT
> message is always encoded in LV mode so PMT message of greater lengths
> can be supported.
>
> Signed-off-by: Henrik Kurelid <henrik@kurelid.se>
> Signed-off-by: Stefan Richter <stefanr@s5r6.in-berlin.de>
> ---
>
> On  2 Oct, Henrik Kurelid wrote:
>> Here is a patch that solves a problem in firedtv that has become major for
>> Swedish DVB-T users the last month or so.
>> It will most likely solve issues seen by other users as well.
>> Please review and comment.
>
> I don't have a CA module, hence can't test it myself.  Is the message
> format vendor-defined or ist there a standard for this?
The Ca2Host and Host2Ca messages are vendor specific. According to the documentation from DE the same message structure applies to all cards
independent of the delivery system. The patch have been verified by myself on DVB-T+CA and at least one user on the DE forums with a similar setup.

> Anyway, I am resending this patch for Mauro to apply, since the original
> posting had lines wrapped.  I also took the liberty to standardize the
> hexadecimal constants to lowercase to match the rest of firedtv-avc.c.
Thanks for cleaning up my mess again, Stefan. I really need to configure my mail agent better!

>  drivers/media/dvb/firewire/firedtv-avc.c |   38 ++++++++++++-----------
>  1 file changed, 20 insertions(+), 18 deletions(-)
>
> Index: linux-2.6.32-rc1/drivers/media/dvb/firewire/firedtv-avc.c
> ===================================================================
> --- linux-2.6.32-rc1.orig/drivers/media/dvb/firewire/firedtv-avc.c
> +++ linux-2.6.32-rc1/drivers/media/dvb/firewire/firedtv-avc.c
> @@ -1050,28 +1050,28 @@ int avc_ca_pmt(struct firedtv *fdtv, cha
>  	c->operand[4] = 0; /* slot */
>  	c->operand[5] = SFE_VENDOR_TAG_CA_PMT; /* ca tag */
>  	c->operand[6] = 0; /* more/last */
> -	/* c->operand[7] = XXXprogram_info_length + 17; */ /* length */
> -	c->operand[8] = list_management;
> -	c->operand[9] = 0x01; /* pmt_cmd=OK_descramble */
> +	/* Use three bytes for length field in case length > 127 */
> +	c->operand[10] = list_management;
> +	c->operand[11] = 0x01; /* pmt_cmd=OK_descramble */
>
>  	/* TS program map table */
>
> -	c->operand[10] = 0x02; /* Table id=2 */
> -	c->operand[11] = 0x80; /* Section syntax + length */
> -	/* c->operand[12] = XXXprogram_info_length + 12; */
> -	c->operand[13] = msg[1]; /* Program number */
> -	c->operand[14] = msg[2];
> -	c->operand[15] = 0x01; /* Version number=0 + current/next=1 */
> -	c->operand[16] = 0x00; /* Section number=0 */
> -	c->operand[17] = 0x00; /* Last section number=0 */
> -	c->operand[18] = 0x1f; /* PCR_PID=1FFF */
> -	c->operand[19] = 0xff;
> -	c->operand[20] = (program_info_length >> 8); /* Program info length */
> -	c->operand[21] = (program_info_length & 0xff);
> +	c->operand[12] = 0x02; /* Table id=2 */
> +	c->operand[13] = 0x80; /* Section syntax + length */
> +	/* c->operand[14] = XXXprogram_info_length + 12; */
> +	c->operand[15] = msg[1]; /* Program number */
> +	c->operand[16] = msg[2];
> +	c->operand[17] = 0x01; /* Version number=0 + current/next=1 */
> +	c->operand[18] = 0x00; /* Section number=0 */
> +	c->operand[19] = 0x00; /* Last section number=0 */
> +	c->operand[20] = 0x1f; /* PCR_PID=1FFF */
> +	c->operand[21] = 0xff;
> +	c->operand[22] = (program_info_length >> 8); /* Program info length */
> +	c->operand[23] = (program_info_length & 0xff);
>
>  	/* CA descriptors at programme level */
>  	read_pos = 6;
> -	write_pos = 22;
> +	write_pos = 24;
>  	if (program_info_length > 0) {
>  		pmt_cmd_id = msg[read_pos++];
>  		if (pmt_cmd_id != 1 && pmt_cmd_id != 4)
> @@ -1113,8 +1113,10 @@ int avc_ca_pmt(struct firedtv *fdtv, cha
>  	c->operand[write_pos++] = 0x00;
>  	c->operand[write_pos++] = 0x00;
>
> -	c->operand[7] = write_pos - 8;
> -	c->operand[12] = write_pos - 13;
> +	c->operand[7] = 0x82;
> +	c->operand[8] = (write_pos - 10) >> 8;
> +	c->operand[9] = (write_pos - 10) & 0xff;
> +	c->operand[14] = write_pos - 15;
>
>  	crc32_csum = crc32_be(0, &c->operand[10], c->operand[12] - 1);
>  	c->operand[write_pos - 4] = (crc32_csum >> 24) & 0xff;
>
>
> --
> Stefan Richter
> -=====-==--= =-=- ---==
> http://arcgraph.de/sr/
>

