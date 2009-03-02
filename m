Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtpout.eastlink.ca ([24.222.0.30]:53322 "EHLO
	smtpout.eastlink.ca" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752626AbZCBWDj (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Mon, 2 Mar 2009 17:03:39 -0500
Received: from ip05.eastlink.ca ([24.222.39.68])
 by mta01.eastlink.ca (Sun Java System Messaging Server 6.2-4.03 (built Sep 22
 2005)) with ESMTP id <0KFW00BKGEK0B8F1@mta01.eastlink.ca> for
 linux-media@vger.kernel.org; Mon, 02 Mar 2009 17:33:37 -0400 (AST)
Date: Mon, 02 Mar 2009 17:33:36 -0400
From: JJ <ve1jot@eastlink.ca>
Subject: Re: [linux-dvb] WinTV HVR-1800 analog Satus
In-reply-to: <49AC1494.6030101@linuxtv.org>
To: linux-media@vger.kernel.org
Message-id: <49AC50B0.5020706@eastlink.ca>
MIME-version: 1.0
Content-type: text/plain; charset=ISO-8859-1; format=flowed
Content-transfer-encoding: 7BIT
References: <49AAB995.8090702@campus.upb.de>
 <BD55C643-1E24-4315-8F9D-ACC914AEFE0C@systemoverload.net>
 <49AC1494.6030101@linuxtv.org>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Steven Toth wrote:
> Dustin Coates wrote:
>   
>> Any update on the status of analouge for this card? I really would  
>> like to switch back to Linux as my mce solution, but last time I did,  
>> the analouge was terrible, and I was getting no answers on the list...
>>     
>
> Last I checked it worked fine for me.
>
> - Steve
>
> _______________________________________________
> linux-dvb users mailing list
> For V4L/DVB development, please use instead linux-media@vger.kernel.org
> linux-dvb@linuxtv.org
> http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
>
>   
not working here either...works very occasionally:


[19004.286089] tuner' 4-0042: chip found @ 0x84 (cx23885[0])
[19004.321897] tda829x 4-0042: could not clearly identify tuner address, 
defaulting to 60
[19004.379168] tda18271 4-0060: creating new instance
[19004.413360] TDA18271HD/C1 detected @ 4-0060
[19005.580369] tda829x 4-0042: type set to tda8295+18271
[19828.639583] Firmware and/or mailbox pointer not initialized or 
corrupted, signature = 0x7bfeffff, cmd = STOP_CAPTURE
[19829.749376] Firmware and/or mailbox pointer not initialized or 
corrupted, signature = 0x7bfeffff, cmd = PING_FW
[19829.749445] firmware: requesting v4l-cx23885-enc.fw
[19926.468016] ERROR: API Mailbox timeout
[19927.540420] ERROR: Mailbox appears to be in use (3), cmd = PING_FW
[19927.540487] firmware: requesting v4l-cx23885-enc.fw
[20011.373363] tda18271_calc_bp_filter: error -34 on line 567
[20011.600033] tda18271_calc_km: error -34 on line 584
[20011.637355] tda18271_calc_rf_band: error -34 on line 601
[20011.637365] tda18271_calc_gain_taper: error -34 on line 618
[20012.076367] tda18271_calc_ir_measure: error -34 on line 635
[20012.076376] tda18271_calc_bp_filter: error -34 on line 567
[20012.076380] tda18271_calc_rf_band: error -34 on line 601
[20012.076385] tda18271_calc_gain_taper: error -34 on line 618
[20013.681363] tda18271_calc_bp_filter: error -34 on line 567
[20013.908029] tda18271_calc_km: error -34 on line 584
[20013.944363] tda18271_calc_rf_band: error -34 on line 601
[20013.944373] tda18271_calc_gain_taper: error -34 on line 618
[20014.384363] tda18271_calc_ir_measure: error -34 on line 635
[20014.384372] tda18271_calc_bp_filter: error -34 on line 567
[20014.384376] tda18271_calc_rf_band: error -34 on line 601
[20014.384381] tda18271_calc_gain_taper: error -34 on line 618
[20015.984374] tda18271_calc_bp_filter: error -34 on line 567
[20016.212029] tda18271_calc_km: error -34 on line 584
[20016.248369] tda18271_calc_rf_band: error -34 on line 601
[20016.248379] tda18271_calc_gain_taper: error -34 on line 618
[20016.688363] tda18271_calc_ir_measure: error -34 on line 635
[20016.688372] tda18271_calc_bp_filter: error -34 on line 567
[20016.688376] tda18271_calc_rf_band: error -34 on line 601
[20016.688380] tda18271_calc_gain_taper: error -34 on line 618
[20018.289362] tda18271_calc_bp_filter: error -34 on line 567
[20018.516033] tda18271_calc_km: error -34 on line 584
[20018.553355] tda18271_calc_rf_band: error -34 on line 601
[20018.553364] tda18271_calc_gain_taper: error -34 on line 618
[20018.992373] tda18271_calc_ir_measure: error -34 on line 635
[20018.992381] tda18271_calc_bp_filter: error -34 on line 567
[20018.992386] tda18271_calc_rf_band: error -34 on line 601
[20018.992392] tda18271_calc_gain_taper: error -34 on line 618


