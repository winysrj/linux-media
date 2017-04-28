Return-path: <linux-media-owner@vger.kernel.org>
Received: from vader.hardeman.nu ([95.142.160.32]:32967 "EHLO hardeman.nu"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1033886AbdD1QqF (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Fri, 28 Apr 2017 12:46:05 -0400
Date: Fri, 28 Apr 2017 18:46:02 +0200
From: David =?iso-8859-1?Q?H=E4rdeman?= <david@hardeman.nu>
To: Sean Young <sean@mess.org>
Cc: linux-media@vger.kernel.org, mchehab@s-opensource.com
Subject: Re: [PATCH 6/6] rc-core: add protocol to EVIOC[GS]KEYCODE_V2 ioctl
Message-ID: <20170428164602.gdq7vw47soxfw3wl@hardeman.nu>
References: <149332488240.32431.6597996407440701793.stgit@zeus.hardeman.nu>
 <149332526341.32431.11307248841385136294.stgit@zeus.hardeman.nu>
 <20170428114053.GA21792@gofer.mess.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20170428114053.GA21792@gofer.mess.org>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Fri, Apr 28, 2017 at 12:40:53PM +0100, Sean Young wrote:
>On Thu, Apr 27, 2017 at 10:34:23PM +0200, David Härdeman wrote:
...
>> This patch changes how the "input_keymap_entry" struct is interpreted
>> by rc-core by casting it to "rc_keymap_entry":
>> 
>> struct rc_scancode {
>> 	__u16 protocol;
>> 	__u16 reserved[3];
>> 	__u64 scancode;
>> }
>> 
>> struct rc_keymap_entry {
>> 	__u8  flags;
>> 	__u8  len;
>> 	__u16 index;
>> 	__u32 keycode;
>> 	union {
>> 		struct rc_scancode rc;
>> 		__u8 raw[32];
>> 	};
>> };
>> 
>> The u64 scancode member is large enough for all current protocols and it
>> would be possible to extend it in the future should it be necessary for
>> some exotic protocol.
>> 
>> The main advantage with this change is that the protocol is made explicit,
>> which means that we're not throwing away data (the protocol type).
>> 
>> This also means that struct rc_map no longer hardcodes the protocol, meaning
>> that keytables with mixed entries are possible.
>> 
>> Heuristics are also added to hopefully do the right thing with older
>> ioctls in order to preserve backwards compatibility.
>
>The current ioctls do not provide any protocol information, so they should
>continue to match any protocol. Those heuristics aren't good enough.
>
>Another way of doing is to have a bitmask of protocols, and default to
>RC_BIT_ALL for current ioctls.

I've been mulling that approach as well, but slightly different. My
alternative approach is based on repurposing RC_TYPE_UNKNOWN as a kind
of catch-all which will match any scancode. I'll post a patch showing
the alternative approach straight away.

>> Note that the heuristics are not 100% guaranteed to get things right.
>> That is unavoidable since the protocol information simply isn't there
>> when userspace calls the previous ioctl() types.
>> 
>> However, that is somewhat mitigated by the fact that the "only"
>> userspace binary which might need to change is ir-keytable. Userspace
>> programs which simply consume input events (i.e. the vast majority)
>> won't have to change.
>
>For this to be accepted we would need ir-keytable changes too so it can
>be tested.

I know. But I'll postpone those patches until we have more of a
consensus on the right approach to take.

-- 
David Härdeman
