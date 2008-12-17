Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from fg-out-1718.google.com ([72.14.220.155])
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <devin.heitmueller@gmail.com>) id 1LCxPm-0007m2-R2
	for linux-dvb@linuxtv.org; Wed, 17 Dec 2008 15:30:20 +0100
Received: by fg-out-1718.google.com with SMTP id e21so1645696fga.25
	for <linux-dvb@linuxtv.org>; Wed, 17 Dec 2008 06:30:15 -0800 (PST)
Message-ID: <412bdbff0812170630j4db7bcc6p4deaef3d038e4839@mail.gmail.com>
Date: Wed, 17 Dec 2008 09:30:15 -0500
From: "Devin Heitmueller" <devin.heitmueller@gmail.com>
To: pongo_bob@yahoo.co.uk
In-Reply-To: <730052.59111.qm@web27707.mail.ukl.yahoo.com>
MIME-Version: 1.0
Content-Disposition: inline
References: <412bdbff0812170539n62490614ia7fee4e1689f91@mail.gmail.com>
	<730052.59111.qm@web27707.mail.ukl.yahoo.com>
Cc: linux-dvb@linuxtv.org
Subject: Re: [linux-dvb] Hauppauge Nova-TD-500 84xxx remote control
List-Unsubscribe: <http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb>,
	<mailto:linux-dvb-request@linuxtv.org?subject=unsubscribe>
List-Archive: <http://www.linuxtv.org/pipermail/linux-dvb>
List-Post: <mailto:linux-dvb@linuxtv.org>
List-Help: <mailto:linux-dvb-request@linuxtv.org?subject=help>
List-Subscribe: <http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb>,
	<mailto:linux-dvb-request@linuxtv.org?subject=subscribe>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Sender: linux-dvb-bounces@linuxtv.org
Errors-To: linux-dvb-bounces+mchehab=infradead.org@linuxtv.org
List-ID: <linux-dvb@linuxtv.org>

On Wed, Dec 17, 2008 at 9:27 AM, Bob <pongo_bob@yahoo.co.uk> wrote:
>
> --- On Wed, 17/12/08, Devin Heitmueller <devin.heitmueller@gmail.com> wrote:
>
>> From: Devin Heitmueller <devin.heitmueller@gmail.com>
>> Subject: Re: [linux-dvb] Hauppauge Nova-TD-500 84xxx remote control
>> To: pongo_bob@yahoo.co.uk
>> Cc: linux-dvb@linuxtv.org
>> Date: Wednesday, 17 December, 2008, 1:39 PM
>> On Wed, Dec 17, 2008 at 7:14 AM, Bob
>> <pongo_bob@yahoo.co.uk> wrote:
>> > Hi,
>> >  I used the following kludge :
>> >
>> >  The code for handling the remote is missing in
>> linux/drivers/media/dvb/dvb-usb/dib0700_devices.c. Around
>> line 1402 in you need to add
>> >
>> >                        },
>> >                },
>> >
>> >                .rc_interval      =
>> DEFAULT_RC_INTERVAL,
>> >                .rc_key_map       = dib0700_rc_keys,
>> >                .rc_key_map_size  =
>> ARRAY_SIZE(dib0700_rc_keys),
>> >                .rc_query         = dib0700_rc_query
>> >
>> > pinched from the remotes above.
>> >
>> > This enables the remote if you recompile and reload
>> the module you should see a new input device in dmesg, in my
>> case I can cat /dev/input/event4 and see the key presses.
>> >
>> > Unfortunately , the code in dib0700_rc_query always
>> returns the last key pressed so you get an event every 150mS
>> with the same key in it. So on to the next kludge :
>> >
>> > At the top of dib0700_rc_query I added:
>> >
>> > static int toggle;
>> >
>> > and after i = dib0700_ctrl_rd( blah blah) :
>> >
>> > if ( key[2] == toggle )
>> >  return 0;
>> > toggle = key[2];
>> >
>> > This checks if the key fetched from the remote is the
>> same as the last and returns if it is thus dumping all the
>> repeats from dib0700_ctrl_rd;
>> >
>> > Now you should find that UP , DOWN , LEFT and RIGHT
>> keys work ok but not much else.
>> >
>> > Kludge No.3 coming up :
>> > Starting around line 612 in dib0700_devices.c are the
>> key mappings for the Hauppauge remote. I changed the mapping
>> for KEY_OK to KEY_ENTER so now I can navigate menus and
>> select items.
>> >
>> > And that is as far as I've got ..
>>
>> Hello Bob,
>>
>> Are you using the latest code and 1.20 firmware?  I pushed
>> in a fix on
>> December 8 that as far as I know addressed the last of the
>> remaining
>> dib0700 IR issues.
>>
>> It is possible that your device is missing it's RC
>> declaration, which
>> I can add.  But you shouldn't be seeing any more repeat
>> problems.
>>
>> If people are still having dib0700 IR issues, I would like
>> to hear
>> about it, since I thought I fixed them all...
>>
>> Devin
>>
>> --
>> Devin J. Heitmueller
>> http://www.devinheitmueller.com
>> AIM: devinheitmueller
>
> Hi Devin ,
>  I am running the 1.20 firmware but missed that fix. I've just downloaded and tested the latest code and it works fine after enabling the remote.
>
> Many thanks for your help with this.

Well, that's good.  I was worried there for a second.  :-)

If you want to submit a patch to make your remote control work, that
would help others who are using the same hardware as you (either post
it to the list, or if you prefer just send me the "hg diff" of your
working directory and I will do it on your behalf).

Thanks,

Devin

-- 
Devin J. Heitmueller
http://www.devinheitmueller.com
AIM: devinheitmueller

_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
