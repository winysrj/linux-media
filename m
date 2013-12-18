Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.kapsi.fi ([217.30.184.167]:36902 "EHLO mail.kapsi.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753536Ab3LROkS (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Wed, 18 Dec 2013 09:40:18 -0500
Message-ID: <52B1B3CD.8010103@iki.fi>
Date: Wed, 18 Dec 2013 16:40:13 +0200
From: Antti Palosaari <crope@iki.fi>
MIME-Version: 1.0
To: Mauro Carvalho Chehab <m.chehab@samsung.com>
CC: linux-media@vger.kernel.org
Subject: Re: [PATCH REVIEW 03/18] Montage M88DS3103 DVB-S/S2 demodulator driver
References: <1386541895-8634-1-git-send-email-crope@iki.fi> <1386541895-8634-4-git-send-email-crope@iki.fi> <20131218103535.2a7a2f32@samsung.com>
In-Reply-To: <20131218103535.2a7a2f32@samsung.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 18.12.2013 14:35, Mauro Carvalho Chehab wrote:
> Hi Antti,
>
> Em Mon,  9 Dec 2013 00:31:20 +0200
> Antti Palosaari <crope@iki.fi> escreveu:
>
>> DVB-S/S2 satellite television demodulator driver.
>> + *    You should have received a copy of the GNU General Public License along
>> + *    with this program; if not, write to the Free Software Foundation, Inc.,
>> + *    51 Franklin Street, Fifth Floor, Boston, MA 02110-1301 USA.
>> + */
>
> New versions of checkpatch complain about the above:
>
> ERROR: Do not include the paragraph about writing to the Free Software Foundation's mailing address from the sample GPL notice. The FSF has changed addresses in the past, and may do so again. Linux already includes a copy of the GPL.
> #73: FILE: drivers/media/dvb-frontends/m88ds3103.c:16:
> + *    You should have received a copy of the GNU General Public License along$
>
> What they're likely want to prevent is to have future big mass patches just
> to fix the GNU address.
>
> This is not needed, anyway, as kernel has the /COPYING file with has the
> GPLv2 license.
>
> So, could you please remove this and resend the pull request?

Hey, that is written almost year ago and those new checkpatch 
requirements are very new, I think from latest release candidate version.

However, I could send new patch top of that set which meets latest 
3.13-rc4 checkpatch requirements.

>> +static int m88ds3103_wr_regs(struct m88ds3103_priv *priv,
>> +	u8 buf[1 + len];
>
> Please, don't use dynamic buffer.

Same here. Fixed already by later patched.

>> +static int m88ds3103_rd_regs(struct m88ds3103_priv *priv,
> Same here.

Same here. Fixed already by later patched.



>> diff --git a/drivers/media/dvb-frontends/m88ds3103_priv.h b/drivers/media/dvb-frontends/m88ds3103_priv.h

>> +static const struct m88ds3103_reg_val m88ds3103_dvbs_init_reg_vals[] = {
>
> Why to put this inside a header file? Is it shared with some other c file?

It is private header file, not the shared one which is named as 
m88ds3103.h. Having inittabs inside private header file is common 
practice among DVB frontend driver. I think almost all demod driver has 
done it similarly. I suspect the main reason is just to separate static 
stuff out from code to keep driver file itself shorter.

I think it is good practice. It is place for another discussion whether 
it is good practice or not.

regards
Antti

-- 
http://palosaari.fi/
