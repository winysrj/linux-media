Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-qk0-f173.google.com ([209.85.220.173]:35293 "EHLO
        mail-qk0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753796AbdCFJbJ (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Mon, 6 Mar 2017 04:31:09 -0500
Received: by mail-qk0-f173.google.com with SMTP id v125so82607608qkh.2
        for <linux-media@vger.kernel.org>; Mon, 06 Mar 2017 01:31:08 -0800 (PST)
Subject: Re: [PATCH 08/26] brcmsmac: make some local variables 'static const'
 to reduce stack size
To: Arnd Bergmann <arnd@arndb.de>, kasan-dev@googlegroups.com
References: <20170302163834.2273519-1-arnd@arndb.de>
 <20170302163834.2273519-9-arnd@arndb.de>
Cc: Andrey Ryabinin <aryabinin@virtuozzo.com>,
        Alexander Potapenko <glider@google.com>,
        Dmitry Vyukov <dvyukov@google.com>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-media@vger.kernel.org,
        linux-wireless@vger.kernel.org,
        kernel-build-reports@lists.linaro.org,
        "David S . Miller" <davem@davemloft.net>
From: Arend Van Spriel <arend.vanspriel@broadcom.com>
Message-ID: <227c8e5a-fa20-0300-1cb0-1d3ef17deb19@broadcom.com>
Date: Mon, 6 Mar 2017 10:30:58 +0100
MIME-Version: 1.0
In-Reply-To: <20170302163834.2273519-9-arnd@arndb.de>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 2-3-2017 17:38, Arnd Bergmann wrote:
> With KASAN and a couple of other patches applied, this driver is one
> of the few remaining ones that actually use more than 2048 bytes of
> kernel stack:
> 
> broadcom/brcm80211/brcmsmac/phy/phy_n.c: In function 'wlc_phy_workarounds_nphy_gainctrl':
> broadcom/brcm80211/brcmsmac/phy/phy_n.c:16065:1: warning: the frame size of 3264 bytes is larger than 2048 bytes [-Wframe-larger-than=]
> broadcom/brcm80211/brcmsmac/phy/phy_n.c: In function 'wlc_phy_workarounds_nphy':
> broadcom/brcm80211/brcmsmac/phy/phy_n.c:17138:1: warning: the frame size of 2864 bytes is larger than 2048 bytes [-Wframe-larger-than=]
> 
> Here, I'm reducing the stack size by marking as many local variables as
> 'static const' as I can without changing the actual code.

Acked-by: Arend van Spriel <arend.vanspriel@broadcom.com>
> Signed-off-by: Arnd Bergmann <arnd@arndb.de>
> ---
>  .../broadcom/brcm80211/brcmsmac/phy/phy_n.c        | 197 ++++++++++-----------
>  1 file changed, 97 insertions(+), 100 deletions(-)
> 
> diff --git a/drivers/net/wireless/broadcom/brcm80211/brcmsmac/phy/phy_n.c b/drivers/net/wireless/broadcom/brcm80211/brcmsmac/phy/phy_n.c
> index 42dc8e1f483d..48a4df488d75 100644
> --- a/drivers/net/wireless/broadcom/brcm80211/brcmsmac/phy/phy_n.c
> +++ b/drivers/net/wireless/broadcom/brcm80211/brcmsmac/phy/phy_n.c
> @@ -14764,8 +14764,8 @@ static void wlc_phy_ipa_restore_tx_digi_filts_nphy(struct brcms_phy *pi)
>  }
>  
>  static void
> -wlc_phy_set_rfseq_nphy(struct brcms_phy *pi, u8 cmd, u8 *events, u8 *dlys,
> -		       u8 len)
> +wlc_phy_set_rfseq_nphy(struct brcms_phy *pi, u8 cmd, const u8 *events,
> +		       const u8 *dlys, u8 len)
>  {
>  	u32 t1_offset, t2_offset;
>  	u8 ctr;
> @@ -15240,16 +15240,16 @@ static void wlc_phy_workarounds_nphy_gainctrl_2057_rev5(struct brcms_phy *pi)
>  static void wlc_phy_workarounds_nphy_gainctrl_2057_rev6(struct brcms_phy *pi)
>  {
>  	u16 currband;
> -	s8 lna1G_gain_db_rev7[] = { 9, 14, 19, 24 };
> -	s8 *lna1_gain_db = NULL;
> -	s8 *lna1_gain_db_2 = NULL;
> -	s8 *lna2_gain_db = NULL;
> -	s8 tiaA_gain_db_rev7[] = { -9, -6, -3, 0, 3, 3, 3, 3, 3, 3 };
> -	s8 *tia_gain_db;
> -	s8 tiaA_gainbits_rev7[] = { 0, 1, 2, 3, 4, 4, 4, 4, 4, 4 };
> -	s8 *tia_gainbits;
> -	u16 rfseqA_init_gain_rev7[] = { 0x624f, 0x624f };
> -	u16 *rfseq_init_gain;
> +	static const s8 lna1G_gain_db_rev7[] = { 9, 14, 19, 24 };
> +	const s8 *lna1_gain_db = NULL;
> +	const s8 *lna1_gain_db_2 = NULL;
> +	const s8 *lna2_gain_db = NULL;
> +	static const s8 tiaA_gain_db_rev7[] = { -9, -6, -3, 0, 3, 3, 3, 3, 3, 3 };
> +	const s8 *tia_gain_db;
> +	static const s8 tiaA_gainbits_rev7[] = { 0, 1, 2, 3, 4, 4, 4, 4, 4, 4 };
> +	const s8 *tia_gainbits;
> +	static const u16 rfseqA_init_gain_rev7[] = { 0x624f, 0x624f };
> +	const u16 *rfseq_init_gain;
>  	u16 init_gaincode;
>  	u16 clip1hi_gaincode;
>  	u16 clip1md_gaincode = 0;
> @@ -15310,10 +15310,9 @@ static void wlc_phy_workarounds_nphy_gainctrl_2057_rev6(struct brcms_phy *pi)
>  
>  			if ((freq <= 5080) || (freq == 5825)) {
>  
> -				s8 lna1A_gain_db_rev7[] = { 11, 16, 20, 24 };
> -				s8 lna1A_gain_db_2_rev7[] = {
> -					11, 17, 22, 25};
> -				s8 lna2A_gain_db_rev7[] = { -1, 6, 10, 14 };
> +				static const s8 lna1A_gain_db_rev7[] = { 11, 16, 20, 24 };
> +				static const s8 lna1A_gain_db_2_rev7[] = { 11, 17, 22, 25};
> +				static const s8 lna2A_gain_db_rev7[] = { -1, 6, 10, 14 };
>  
>  				crsminu_th = 0x3e;
>  				lna1_gain_db = lna1A_gain_db_rev7;
> @@ -15321,10 +15320,9 @@ static void wlc_phy_workarounds_nphy_gainctrl_2057_rev6(struct brcms_phy *pi)
>  				lna2_gain_db = lna2A_gain_db_rev7;
>  			} else if ((freq >= 5500) && (freq <= 5700)) {
>  
> -				s8 lna1A_gain_db_rev7[] = { 11, 17, 21, 25 };
> -				s8 lna1A_gain_db_2_rev7[] = {
> -					12, 18, 22, 26};
> -				s8 lna2A_gain_db_rev7[] = { 1, 8, 12, 16 };
> +				static const s8 lna1A_gain_db_rev7[] = { 11, 17, 21, 25 };
> +				static const s8 lna1A_gain_db_2_rev7[] = { 12, 18, 22, 26};
> +				static const s8 lna2A_gain_db_rev7[] = { 1, 8, 12, 16 };
>  
>  				crsminu_th = 0x45;
>  				clip1md_gaincode_B = 0x14;
> @@ -15335,10 +15333,9 @@ static void wlc_phy_workarounds_nphy_gainctrl_2057_rev6(struct brcms_phy *pi)
>  				lna2_gain_db = lna2A_gain_db_rev7;
>  			} else {
>  
> -				s8 lna1A_gain_db_rev7[] = { 12, 18, 22, 26 };
> -				s8 lna1A_gain_db_2_rev7[] = {
> -					12, 18, 22, 26};
> -				s8 lna2A_gain_db_rev7[] = { -1, 6, 10, 14 };
> +				static const s8 lna1A_gain_db_rev7[] = { 12, 18, 22, 26 };
> +				static const s8 lna1A_gain_db_2_rev7[] = { 12, 18, 22, 26};
> +				static const s8 lna2A_gain_db_rev7[] = { -1, 6, 10, 14 };
>  
>  				crsminu_th = 0x41;
>  				lna1_gain_db = lna1A_gain_db_rev7;
> @@ -15450,65 +15447,65 @@ static void wlc_phy_workarounds_nphy_gainctrl(struct brcms_phy *pi)
>  		NPHY_RFSEQ_CMD_CLR_HIQ_DIS,
>  		NPHY_RFSEQ_CMD_SET_HPF_BW
>  	};
> -	u8 rfseq_updategainu_dlys[] = { 10, 30, 1 };
> -	s8 lna1G_gain_db[] = { 7, 11, 16, 23 };
> -	s8 lna1G_gain_db_rev4[] = { 8, 12, 17, 25 };
> -	s8 lna1G_gain_db_rev5[] = { 9, 13, 18, 26 };
> -	s8 lna1G_gain_db_rev6[] = { 8, 13, 18, 25 };
> -	s8 lna1G_gain_db_rev6_224B0[] = { 10, 14, 19, 27 };
> -	s8 lna1A_gain_db[] = { 7, 11, 17, 23 };
> -	s8 lna1A_gain_db_rev4[] = { 8, 12, 18, 23 };
> -	s8 lna1A_gain_db_rev5[] = { 6, 10, 16, 21 };
> -	s8 lna1A_gain_db_rev6[] = { 6, 10, 16, 21 };
> -	s8 *lna1_gain_db = NULL;
> -	s8 lna2G_gain_db[] = { -5, 6, 10, 14 };
> -	s8 lna2G_gain_db_rev5[] = { -3, 7, 11, 16 };
> -	s8 lna2G_gain_db_rev6[] = { -5, 6, 10, 14 };
> -	s8 lna2G_gain_db_rev6_224B0[] = { -5, 6, 10, 15 };
> -	s8 lna2A_gain_db[] = { -6, 2, 6, 10 };
> -	s8 lna2A_gain_db_rev4[] = { -5, 2, 6, 10 };
> -	s8 lna2A_gain_db_rev5[] = { -7, 0, 4, 8 };
> -	s8 lna2A_gain_db_rev6[] = { -7, 0, 4, 8 };
> -	s8 *lna2_gain_db = NULL;
> -	s8 tiaG_gain_db[] = {
> +	static const u8 rfseq_updategainu_dlys[] = { 10, 30, 1 };
> +	static const s8 lna1G_gain_db[] = { 7, 11, 16, 23 };
> +	static const s8 lna1G_gain_db_rev4[] = { 8, 12, 17, 25 };
> +	static const s8 lna1G_gain_db_rev5[] = { 9, 13, 18, 26 };
> +	static const s8 lna1G_gain_db_rev6[] = { 8, 13, 18, 25 };
> +	static const s8 lna1G_gain_db_rev6_224B0[] = { 10, 14, 19, 27 };
> +	static const s8 lna1A_gain_db[] = { 7, 11, 17, 23 };
> +	static const s8 lna1A_gain_db_rev4[] = { 8, 12, 18, 23 };
> +	static const s8 lna1A_gain_db_rev5[] = { 6, 10, 16, 21 };
> +	static const s8 lna1A_gain_db_rev6[] = { 6, 10, 16, 21 };
> +	const s8 *lna1_gain_db = NULL;
> +	static const s8 lna2G_gain_db[] = { -5, 6, 10, 14 };
> +	static const s8 lna2G_gain_db_rev5[] = { -3, 7, 11, 16 };
> +	static const s8 lna2G_gain_db_rev6[] = { -5, 6, 10, 14 };
> +	static const s8 lna2G_gain_db_rev6_224B0[] = { -5, 6, 10, 15 };
> +	static const s8 lna2A_gain_db[] = { -6, 2, 6, 10 };
> +	static const s8 lna2A_gain_db_rev4[] = { -5, 2, 6, 10 };
> +	static const s8 lna2A_gain_db_rev5[] = { -7, 0, 4, 8 };
> +	static const s8 lna2A_gain_db_rev6[] = { -7, 0, 4, 8 };
> +	const s8 *lna2_gain_db = NULL;
> +	static const s8 tiaG_gain_db[] = {
>  		0x0A, 0x0A, 0x0A, 0x0A, 0x0A, 0x0A, 0x0A, 0x0A, 0x0A, 0x0A };
> -	s8 tiaA_gain_db[] = {
> +	static const s8 tiaA_gain_db[] = {
>  		0x13, 0x13, 0x13, 0x13, 0x13, 0x13, 0x13, 0x13, 0x13, 0x13 };
> -	s8 tiaA_gain_db_rev4[] = {
> +	static const s8 tiaA_gain_db_rev4[] = {
>  		0x0d, 0x0d, 0x0d, 0x0d, 0x0d, 0x0d, 0x0d, 0x0d, 0x0d, 0x0d };
> -	s8 tiaA_gain_db_rev5[] = {
> +	static const s8 tiaA_gain_db_rev5[] = {
>  		0x0d, 0x0d, 0x0d, 0x0d, 0x0d, 0x0d, 0x0d, 0x0d, 0x0d, 0x0d };
> -	s8 tiaA_gain_db_rev6[] = {
> +	static const s8 tiaA_gain_db_rev6[] = {
>  		0x0d, 0x0d, 0x0d, 0x0d, 0x0d, 0x0d, 0x0d, 0x0d, 0x0d, 0x0d };
> -	s8 *tia_gain_db;
> -	s8 tiaG_gainbits[] = {
> +	const s8 *tia_gain_db;
> +	static const s8 tiaG_gainbits[] = {
>  		0x03, 0x03, 0x03, 0x03, 0x03, 0x03, 0x03, 0x03, 0x03, 0x03 };
> -	s8 tiaA_gainbits[] = {
> +	static const s8 tiaA_gainbits[] = {
>  		0x06, 0x06, 0x06, 0x06, 0x06, 0x06, 0x06, 0x06, 0x06, 0x06 };
> -	s8 tiaA_gainbits_rev4[] = {
> +	static const s8 tiaA_gainbits_rev4[] = {
>  		0x04, 0x04, 0x04, 0x04, 0x04, 0x04, 0x04, 0x04, 0x04, 0x04 };
> -	s8 tiaA_gainbits_rev5[] = {
> +	static const s8 tiaA_gainbits_rev5[] = {
>  		0x04, 0x04, 0x04, 0x04, 0x04, 0x04, 0x04, 0x04, 0x04, 0x04 };
> -	s8 tiaA_gainbits_rev6[] = {
> +	static const s8 tiaA_gainbits_rev6[] = {
>  		0x04, 0x04, 0x04, 0x04, 0x04, 0x04, 0x04, 0x04, 0x04, 0x04 };
> -	s8 *tia_gainbits;
> -	s8 lpf_gain_db[] = { 0x00, 0x06, 0x0c, 0x12, 0x12, 0x12 };
> -	s8 lpf_gainbits[] = { 0x00, 0x01, 0x02, 0x03, 0x03, 0x03 };
> -	u16 rfseqG_init_gain[] = { 0x613f, 0x613f, 0x613f, 0x613f };
> -	u16 rfseqG_init_gain_rev4[] = { 0x513f, 0x513f, 0x513f, 0x513f };
> -	u16 rfseqG_init_gain_rev5[] = { 0x413f, 0x413f, 0x413f, 0x413f };
> -	u16 rfseqG_init_gain_rev5_elna[] = {
> +	const s8 *tia_gainbits;
> +	static const s8 lpf_gain_db[] = { 0x00, 0x06, 0x0c, 0x12, 0x12, 0x12 };
> +	static const s8 lpf_gainbits[] = { 0x00, 0x01, 0x02, 0x03, 0x03, 0x03 };
> +	static const u16 rfseqG_init_gain[] = { 0x613f, 0x613f, 0x613f, 0x613f };
> +	static const u16 rfseqG_init_gain_rev4[] = { 0x513f, 0x513f, 0x513f, 0x513f };
> +	static const u16 rfseqG_init_gain_rev5[] = { 0x413f, 0x413f, 0x413f, 0x413f };
> +	static const u16 rfseqG_init_gain_rev5_elna[] = {
>  		0x013f, 0x013f, 0x013f, 0x013f };
> -	u16 rfseqG_init_gain_rev6[] = { 0x513f, 0x513f };
> -	u16 rfseqG_init_gain_rev6_224B0[] = { 0x413f, 0x413f };
> -	u16 rfseqG_init_gain_rev6_elna[] = { 0x113f, 0x113f };
> -	u16 rfseqA_init_gain[] = { 0x516f, 0x516f, 0x516f, 0x516f };
> -	u16 rfseqA_init_gain_rev4[] = { 0x614f, 0x614f, 0x614f, 0x614f };
> -	u16 rfseqA_init_gain_rev4_elna[] = {
> +	static const u16 rfseqG_init_gain_rev6[] = { 0x513f, 0x513f };
> +	static const u16 rfseqG_init_gain_rev6_224B0[] = { 0x413f, 0x413f };
> +	static const u16 rfseqG_init_gain_rev6_elna[] = { 0x113f, 0x113f };
> +	static const u16 rfseqA_init_gain[] = { 0x516f, 0x516f, 0x516f, 0x516f };
> +	static const u16 rfseqA_init_gain_rev4[] = { 0x614f, 0x614f, 0x614f, 0x614f };
> +	static const u16 rfseqA_init_gain_rev4_elna[] = {
>  		0x314f, 0x314f, 0x314f, 0x314f };
> -	u16 rfseqA_init_gain_rev5[] = { 0x714f, 0x714f, 0x714f, 0x714f };
> -	u16 rfseqA_init_gain_rev6[] = { 0x714f, 0x714f };
> -	u16 *rfseq_init_gain;
> +	static const u16 rfseqA_init_gain_rev5[] = { 0x714f, 0x714f, 0x714f, 0x714f };
> +	static const u16 rfseqA_init_gain_rev6[] = { 0x714f, 0x714f };
> +	const u16 *rfseq_init_gain;
>  	u16 initG_gaincode = 0x627e;
>  	u16 initG_gaincode_rev4 = 0x527e;
>  	u16 initG_gaincode_rev5 = 0x427e;
> @@ -15538,10 +15535,10 @@ static void wlc_phy_workarounds_nphy_gainctrl(struct brcms_phy *pi)
>  	u16 clip1mdA_gaincode_rev6 = 0x2084;
>  	u16 clip1md_gaincode = 0;
>  	u16 clip1loG_gaincode = 0x0074;
> -	u16 clip1loG_gaincode_rev5[] = {
> +	static const u16 clip1loG_gaincode_rev5[] = {
>  		0x0062, 0x0064, 0x006a, 0x106a, 0x106c, 0x1074, 0x107c, 0x207c
>  	};
> -	u16 clip1loG_gaincode_rev6[] = {
> +	static const u16 clip1loG_gaincode_rev6[] = {
>  		0x106a, 0x106c, 0x1074, 0x107c, 0x007e, 0x107e, 0x207e, 0x307e
>  	};
>  	u16 clip1loG_gaincode_rev6_224B0 = 0x1074;
> @@ -16066,7 +16063,7 @@ static void wlc_phy_workarounds_nphy_gainctrl(struct brcms_phy *pi)
>  
>  static void wlc_phy_workarounds_nphy(struct brcms_phy *pi)
>  {
> -	u8 rfseq_rx2tx_events[] = {
> +	static const u8 rfseq_rx2tx_events[] = {
>  		NPHY_RFSEQ_CMD_NOP,
>  		NPHY_RFSEQ_CMD_RXG_FBW,
>  		NPHY_RFSEQ_CMD_TR_SWITCH,
> @@ -16076,7 +16073,7 @@ static void wlc_phy_workarounds_nphy(struct brcms_phy *pi)
>  		NPHY_RFSEQ_CMD_EXT_PA
>  	};
>  	u8 rfseq_rx2tx_dlys[] = { 8, 6, 6, 2, 4, 60, 1 };
> -	u8 rfseq_tx2rx_events[] = {
> +	static const u8 rfseq_tx2rx_events[] = {
>  		NPHY_RFSEQ_CMD_NOP,
>  		NPHY_RFSEQ_CMD_EXT_PA,
>  		NPHY_RFSEQ_CMD_TX_GAIN,
> @@ -16085,8 +16082,8 @@ static void wlc_phy_workarounds_nphy(struct brcms_phy *pi)
>  		NPHY_RFSEQ_CMD_RXG_FBW,
>  		NPHY_RFSEQ_CMD_CLR_HIQ_DIS
>  	};
> -	u8 rfseq_tx2rx_dlys[] = { 8, 6, 2, 4, 4, 6, 1 };
> -	u8 rfseq_tx2rx_events_rev3[] = {
> +	static const u8 rfseq_tx2rx_dlys[] = { 8, 6, 2, 4, 4, 6, 1 };
> +	static const u8 rfseq_tx2rx_events_rev3[] = {
>  		NPHY_REV3_RFSEQ_CMD_EXT_PA,
>  		NPHY_REV3_RFSEQ_CMD_INT_PA_PU,
>  		NPHY_REV3_RFSEQ_CMD_TX_GAIN,
> @@ -16096,7 +16093,7 @@ static void wlc_phy_workarounds_nphy(struct brcms_phy *pi)
>  		NPHY_REV3_RFSEQ_CMD_CLR_HIQ_DIS,
>  		NPHY_REV3_RFSEQ_CMD_END
>  	};
> -	u8 rfseq_tx2rx_dlys_rev3[] = { 8, 4, 2, 2, 4, 4, 6, 1 };
> +	static const u8 rfseq_tx2rx_dlys_rev3[] = { 8, 4, 2, 2, 4, 4, 6, 1 };
>  	u8 rfseq_rx2tx_events_rev3[] = {
>  		NPHY_REV3_RFSEQ_CMD_NOP,
>  		NPHY_REV3_RFSEQ_CMD_RXG_FBW,
> @@ -16110,7 +16107,7 @@ static void wlc_phy_workarounds_nphy(struct brcms_phy *pi)
>  	};
>  	u8 rfseq_rx2tx_dlys_rev3[] = { 8, 6, 6, 4, 4, 18, 42, 1, 1 };
>  
> -	u8 rfseq_rx2tx_events_rev3_ipa[] = {
> +	static const u8 rfseq_rx2tx_events_rev3_ipa[] = {
>  		NPHY_REV3_RFSEQ_CMD_NOP,
>  		NPHY_REV3_RFSEQ_CMD_RXG_FBW,
>  		NPHY_REV3_RFSEQ_CMD_TR_SWITCH,
> @@ -16121,15 +16118,15 @@ static void wlc_phy_workarounds_nphy(struct brcms_phy *pi)
>  		NPHY_REV3_RFSEQ_CMD_INT_PA_PU,
>  		NPHY_REV3_RFSEQ_CMD_END
>  	};
> -	u8 rfseq_rx2tx_dlys_rev3_ipa[] = { 8, 6, 6, 4, 4, 16, 43, 1, 1 };
> -	u16 rfseq_rx2tx_dacbufpu_rev7[] = { 0x10f, 0x10f };
> +	static const u8 rfseq_rx2tx_dlys_rev3_ipa[] = { 8, 6, 6, 4, 4, 16, 43, 1, 1 };
> +	static const u16 rfseq_rx2tx_dacbufpu_rev7[] = { 0x10f, 0x10f };
>  
>  	s16 alpha0, alpha1, alpha2;
>  	s16 beta0, beta1, beta2;
>  	u32 leg_data_weights, ht_data_weights, nss1_data_weights,
>  	    stbc_data_weights;
>  	u8 chan_freq_range = 0;
> -	u16 dac_control = 0x0002;
> +	static const u16 dac_control = 0x0002;
>  	u16 aux_adc_vmid_rev7_core0[] = { 0x8e, 0x96, 0x96, 0x96 };
>  	u16 aux_adc_vmid_rev7_core1[] = { 0x8f, 0x9f, 0x9f, 0x96 };
>  	u16 aux_adc_vmid_rev4[] = { 0xa2, 0xb4, 0xb4, 0x89 };
> @@ -16139,8 +16136,8 @@ static void wlc_phy_workarounds_nphy(struct brcms_phy *pi)
>  	u16 aux_adc_gain_rev4[] = { 0x02, 0x02, 0x02, 0x00 };
>  	u16 aux_adc_gain_rev3[] = { 0x02, 0x02, 0x02, 0x00 };
>  	u16 *aux_adc_gain;
> -	u16 sk_adc_vmid[] = { 0xb4, 0xb4, 0xb4, 0x24 };
> -	u16 sk_adc_gain[] = { 0x02, 0x02, 0x02, 0x02 };
> +	static const u16 sk_adc_vmid[] = { 0xb4, 0xb4, 0xb4, 0x24 };
> +	static const u16 sk_adc_gain[] = { 0x02, 0x02, 0x02, 0x02 };
>  	s32 min_nvar_val = 0x18d;
>  	s32 min_nvar_offset_6mbps = 20;
>  	u8 pdetrange;
> @@ -16151,9 +16148,9 @@ static void wlc_phy_workarounds_nphy(struct brcms_phy *pi)
>  	u16 rfseq_rx2tx_lpf_h_hpc_rev7 = 0x77;
>  	u16 rfseq_tx2rx_lpf_h_hpc_rev7 = 0x77;
>  	u16 rfseq_pktgn_lpf_h_hpc_rev7 = 0x77;
> -	u16 rfseq_htpktgn_lpf_hpc_rev7[] = { 0x77, 0x11, 0x11 };
> -	u16 rfseq_pktgn_lpf_hpc_rev7[] = { 0x11, 0x11 };
> -	u16 rfseq_cckpktgn_lpf_hpc_rev7[] = { 0x11, 0x11 };
> +	static const u16 rfseq_htpktgn_lpf_hpc_rev7[] = { 0x77, 0x11, 0x11 };
> +	static const u16 rfseq_pktgn_lpf_hpc_rev7[] = { 0x11, 0x11 };
> +	static const u16 rfseq_cckpktgn_lpf_hpc_rev7[] = { 0x11, 0x11 };
>  	u16 ipalvlshift_3p3_war_en = 0;
>  	u16 rccal_bcap_val, rccal_scap_val;
>  	u16 rccal_tx20_11b_bcap = 0;
> @@ -24291,13 +24288,13 @@ static void wlc_phy_update_txcal_ladder_nphy(struct brcms_phy *pi, u16 core)
>  	u16 bbmult;
>  	u16 tblentry;
>  
> -	struct nphy_txiqcal_ladder ladder_lo[] = {
> +	static const struct nphy_txiqcal_ladder ladder_lo[] = {
>  		{3, 0}, {4, 0}, {6, 0}, {9, 0}, {13, 0}, {18, 0},
>  		{25, 0}, {25, 1}, {25, 2}, {25, 3}, {25, 4}, {25, 5},
>  		{25, 6}, {25, 7}, {35, 7}, {50, 7}, {71, 7}, {100, 7}
>  	};
>  
> -	struct nphy_txiqcal_ladder ladder_iq[] = {
> +	static const struct nphy_txiqcal_ladder ladder_iq[] = {
>  		{3, 0}, {4, 0}, {6, 0}, {9, 0}, {13, 0}, {18, 0},
>  		{25, 0}, {35, 0}, {50, 0}, {71, 0}, {100, 0}, {100, 1},
>  		{100, 2}, {100, 3}, {100, 4}, {100, 5}, {100, 6}, {100, 7}
> @@ -25773,67 +25770,67 @@ wlc_phy_cal_txiqlo_nphy(struct brcms_phy *pi, struct nphy_txgains target_gain,
>  	u16 cal_gain[2];
>  	struct nphy_iqcal_params cal_params[2];
>  	u32 tbl_len;
> -	void *tbl_ptr;
> +	const void *tbl_ptr;
>  	bool ladder_updated[2];
>  	u8 mphase_cal_lastphase = 0;
>  	int bcmerror = 0;
>  	bool phyhang_avoid_state = false;
>  
> -	u16 tbl_tx_iqlo_cal_loft_ladder_20[] = {
> +	static const u16 tbl_tx_iqlo_cal_loft_ladder_20[] = {
>  		0x0300, 0x0500, 0x0700, 0x0900, 0x0d00, 0x1100, 0x1900, 0x1901,
>  		0x1902,
>  		0x1903, 0x1904, 0x1905, 0x1906, 0x1907, 0x2407, 0x3207, 0x4607,
>  		0x6407
>  	};
>  
> -	u16 tbl_tx_iqlo_cal_iqimb_ladder_20[] = {
> +	static const u16 tbl_tx_iqlo_cal_iqimb_ladder_20[] = {
>  		0x0200, 0x0300, 0x0600, 0x0900, 0x0d00, 0x1100, 0x1900, 0x2400,
>  		0x3200,
>  		0x4600, 0x6400, 0x6401, 0x6402, 0x6403, 0x6404, 0x6405, 0x6406,
>  		0x6407
>  	};
>  
> -	u16 tbl_tx_iqlo_cal_loft_ladder_40[] = {
> +	static const u16 tbl_tx_iqlo_cal_loft_ladder_40[] = {
>  		0x0200, 0x0300, 0x0400, 0x0700, 0x0900, 0x0c00, 0x1200, 0x1201,
>  		0x1202,
>  		0x1203, 0x1204, 0x1205, 0x1206, 0x1207, 0x1907, 0x2307, 0x3207,
>  		0x4707
>  	};
>  
> -	u16 tbl_tx_iqlo_cal_iqimb_ladder_40[] = {
> +	static const u16 tbl_tx_iqlo_cal_iqimb_ladder_40[] = {
>  		0x0100, 0x0200, 0x0400, 0x0700, 0x0900, 0x0c00, 0x1200, 0x1900,
>  		0x2300,
>  		0x3200, 0x4700, 0x4701, 0x4702, 0x4703, 0x4704, 0x4705, 0x4706,
>  		0x4707
>  	};
>  
> -	u16 tbl_tx_iqlo_cal_startcoefs[] = {
> +	static const u16 tbl_tx_iqlo_cal_startcoefs[] = {
>  		0x0000, 0x0000, 0x0000, 0x0000, 0x0000, 0x0000, 0x0000, 0x0000,
>  		0x0000
>  	};
>  
> -	u16 tbl_tx_iqlo_cal_cmds_fullcal[] = {
> +	static const u16 tbl_tx_iqlo_cal_cmds_fullcal[] = {
>  		0x8123, 0x8264, 0x8086, 0x8245, 0x8056,
>  		0x9123, 0x9264, 0x9086, 0x9245, 0x9056
>  	};
>  
> -	u16 tbl_tx_iqlo_cal_cmds_recal[] = {
> +	static const u16 tbl_tx_iqlo_cal_cmds_recal[] = {
>  		0x8101, 0x8253, 0x8053, 0x8234, 0x8034,
>  		0x9101, 0x9253, 0x9053, 0x9234, 0x9034
>  	};
>  
> -	u16 tbl_tx_iqlo_cal_startcoefs_nphyrev3[] = {
> +	static const u16 tbl_tx_iqlo_cal_startcoefs_nphyrev3[] = {
>  		0x0000, 0x0000, 0x0000, 0x0000, 0x0000,
>  		0x0000, 0x0000, 0x0000, 0x0000, 0x0000,
>  		0x0000
>  	};
>  
> -	u16 tbl_tx_iqlo_cal_cmds_fullcal_nphyrev3[] = {
> +	static const u16 tbl_tx_iqlo_cal_cmds_fullcal_nphyrev3[] = {
>  		0x8434, 0x8334, 0x8084, 0x8267, 0x8056, 0x8234,
>  		0x9434, 0x9334, 0x9084, 0x9267, 0x9056, 0x9234
>  	};
>  
> -	u16 tbl_tx_iqlo_cal_cmds_recal_nphyrev3[] = {
> +	static const u16 tbl_tx_iqlo_cal_cmds_recal_nphyrev3[] = {
>  		0x8423, 0x8323, 0x8073, 0x8256, 0x8045, 0x8223,
>  		0x9423, 0x9323, 0x9073, 0x9256, 0x9045, 0x9223
>  	};
> 
