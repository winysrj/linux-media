Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-fx0-f215.google.com ([209.85.220.215]:63121 "EHLO
	mail-fx0-f215.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752735Ab0AXVWD convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sun, 24 Jan 2010 16:22:03 -0500
Received: by fxm7 with SMTP id 7so1354346fxm.28
        for <linux-media@vger.kernel.org>; Sun, 24 Jan 2010 13:22:00 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <4B5CA8F8.3000301@crans.ens-cachan.fr>
References: <4B5CA8F8.3000301@crans.ens-cachan.fr>
Date: Mon, 25 Jan 2010 01:22:00 +0400
Message-ID: <1a297b361001241322q2b077683v8ac55b35afb4fe97@mail.gmail.com>
Subject: Re: problem with libdvben50221 and powercam pro V4 [almost solved]
From: Manu Abraham <abraham.manu@gmail.com>
To: DUBOST Brice <dubost@crans.ens-cachan.fr>
Cc: linux-media@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Brice,

On Mon, Jan 25, 2010 at 12:09 AM, DUBOST Brice
<dubost@crans.ens-cachan.fr> wrote:
> Hello
>
> Powercam just made a new version of their cam, the version 4
>
> Unfortunately this CAM doesn't work with gnutv and applications based on
> libdvben50221
>
> This cam return TIMEOUT errors (en50221_stdcam_llci_poll: Error reported
> by stack:-3) after showing the supported ressource id.
>
>
> I found out that this cam works with the test application of the
> libdvben50221
>
> The problem is that this camreturns two times the list of supported ids
> (as shown in the log) this behavior make the llci_lookup_callback
> (en50221_stdcam_llci.c line 338)  failing to give the good ressource_id
> at the second call because there is already a session number (in the
> test app the session number is not tested)
>
> I solved the problem commenting out the test for the session number as
> showed in the joined patch (against the latest dvb-apps, cloned today)
>
> Since I'm not an expert of the libdvben50221, I'm asking the list if
> there is better way to solve this problem and improve my patch so it can
> be integrated upstream.



Very strange that, it responds twice on the same session.
Btw, What DVB driver are you using ? budget_ci or budget_av ?

Regards,
Manu
















>
> Thank you
>
> --
> Brice DUBOST
>
> A: Yes.
>>Q: Are you sure?
>>>A: Because it reverses the logical flow of conversation.
>>>>Q: Why is top posting annoying in email?
>
> Found a CAM on adapter1... waiting...
> en50221_tl_register_slot
> slotid: 0
> tcid: 1
> Press a key to enter menu
> 00:Host originated transport connection 1 connected
> 00:Public resource lookup callback 1 1 1
> 00:CAM connecting to resource 00010041, session_number 1
> 00:CAM successfully connected to resource 00010041, session_number 1
> 00:test_rm_reply_callback
> 00:test_rm_enq_callback
> 00:Public resource lookup callback 2 1 1
> 00:CAM connecting to resource 00020041, session_number 2
> 00:CAM successfully connected to resource 00020041, session_number 2
> 00:test_ai_callback
>  Application type: 01
>  Application manufacturer: 02ca
>  Manufacturer code: 3000
>  Menu string: PCAM V4.1
> 00:Public resource lookup callback 3 1 1
> 00:CAM connecting to resource 00030041, session_number 3
> 00:CAM successfully connected to resource 00030041, session_number 3
> 00:test_ca_info_callback
>  Supported CA ID: 4aa1
>  Supported CA ID: 0100
>  Supported CA ID: 0500
>  Supported CA ID: 0600
>  Supported CA ID: 0601
>  Supported CA ID: 0602
>  Supported CA ID: 0603
>  Supported CA ID: 0604
>  Supported CA ID: 0606
>  Supported CA ID: 0608
>  Supported CA ID: 0614
>  Supported CA ID: 0620
>  Supported CA ID: 0622
>  Supported CA ID: 0624
>  Supported CA ID: 0626
>  Supported CA ID: 0628
>  Supported CA ID: 0668
>  Supported CA ID: 0619
>  Supported CA ID: 1702
>  Supported CA ID: 1722
>  Supported CA ID: 1762
>  Supported CA ID: 0b00
>  Supported CA ID: 0b01
>  Supported CA ID: 0b02
>  Supported CA ID: 0d00
>  Supported CA ID: 0d01
>  Supported CA ID: 0d02
>  Supported CA ID: 0d03
>  Supported CA ID: 0d04
>  Supported CA ID: 0d05
>  Supported CA ID: 0d06
>  Supported CA ID: 0d07
>  Supported CA ID: 0d08
>  Supported CA ID: 0d0c
>  Supported CA ID: 0d0f
>  Supported CA ID: 0d22
>  Supported CA ID: 0d70
>  Supported CA ID: 4aa0
> 00:Connection to resource 00030041, session_number 3 closed
> 00:Public resource lookup callback 3 1 1
> 00:CAM connecting to resource 00030041, session_number 3
> 00:CAM successfully connected to resource 00030041, session_number 3
> 00:test_ca_info_callback
>  Supported CA ID: 4aa1
>  Supported CA ID: 0100
>  Supported CA ID: 0500
>  Supported CA ID: 0600
>  Supported CA ID: 0601
>  Supported CA ID: 0602
>  Supported CA ID: 0603
>  Supported CA ID: 0604
>  Supported CA ID: 0606
>  Supported CA ID: 0608
>  Supported CA ID: 0614
>  Supported CA ID: 0620
>  Supported CA ID: 0622
>  Supported CA ID: 0624
>  Supported CA ID: 0626
>  Supported CA ID: 0628
>  Supported CA ID: 0668
>  Supported CA ID: 0619
>  Supported CA ID: 1702
>  Supported CA ID: 1722
>  Supported CA ID: 1762
>  Supported CA ID: 0b00
>  Supported CA ID: 0b01
>  Supported CA ID: 0b02
>  Supported CA ID: 0d00
>  Supported CA ID: 0d01
>  Supported CA ID: 0d02
>  Supported CA ID: 0d03
>  Supported CA ID: 0d04
>  Supported CA ID: 0d05
>  Supported CA ID: 0d06
>  Supported CA ID: 0d07
>  Supported CA ID: 0d08
>  Supported CA ID: 0d0c
>  Supported CA ID: 0d0f
>  Supported CA ID: 0d22
>  Supported CA ID: 0d70
>  Supported CA ID: 4aa0
>
> 00:Public resource lookup callback 64 1 1
> 00:CAM connecting to resource 00400041, session_number 4
> 00:CAM successfully connected to resource 00400041, session_number 4
> 00:test_mmi_display_control_callback
>  cmd_id: 01
>  mode: 01
> 00:test_mmi_menu_callback
>  title: PCAM V4.1
>  sub_title:
>  bottom:
>  item 1: English
>  item 2: French
>  item 3: Spanish
>  item 4: German
>  item 5: Russian
>  item 6: Arabic A
>  item 7: Arabic B
>  raw_length: 0
>
>
>
