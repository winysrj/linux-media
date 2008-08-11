Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Message-ID: <489F98BC.3060508@siriushk.com>
Date: Mon, 11 Aug 2008 09:41:16 +0800
From: Timothy Lee <timothy.lee@siriushk.com>
MIME-Version: 1.0
To: Michael Krufky <mkrufky@linuxtv.org>
References: <489C16EF.5030004@siriushk.com>
	<489C4056.9080804@linuxtv.org>	<489D4D5D.2020700@siriushk.com>
	<489F2C4A.4070908@linuxtv.org> <489F2D3C.6000002@linuxtv.org>
In-Reply-To: <489F2D3C.6000002@linuxtv.org>
Cc: linux-dvb@linuxtv.org
Subject: Re: [linux-dvb] [PATCH] Support for Magic-Pro DMB-TH usb stick
List-Unsubscribe: <http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb>,
	<mailto:linux-dvb-request@linuxtv.org?subject=unsubscribe>
List-Archive: <http://www.linuxtv.org/pipermail/linux-dvb>
List-Post: <mailto:linux-dvb@linuxtv.org>
List-Help: <mailto:linux-dvb-request@linuxtv.org?subject=help>
List-Subscribe: <http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb>,
	<mailto:linux-dvb-request@linuxtv.org?subject=subscribe>
Content-Type: multipart/mixed; boundary="===============1298459602=="
Mime-version: 1.0
Sender: linux-dvb-bounces@linuxtv.org
Errors-To: linux-dvb-bounces+mchehab=infradead.org@linuxtv.org
List-ID: <linux-dvb@linuxtv.org>

This is a multi-part message in MIME format.
--===============1298459602==
Content-Type: multipart/alternative;
 boundary="------------090806010303030304090305"

This is a multi-part message in MIME format.
--------------090806010303030304090305
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit

Michael Krufky wrote:
> Michael Krufky wrote:
>    
>> Timothy Lee wrote:
>>      
>>> Michael Krufky wrote:
>>>        
>>>> Timothy Lee wrote:
>>>>
>>>>          
>>>>> Attached is a patch against v4l-dvb repository to add support for
>>>>> Magic-Pro DMB-TH usb stick.  DMB-TH is the HDTV broadcast standard used
>>>>> in Hong Kong and China.
>>>>>
>>>>> Regards,
>>>>> Timothy Lee
>>>>>
>>>>>            
>>>> Timothy,
>>>>
>>>> In order for your patch to be applied to the kernel, a sign-off is
>>>> required.
>>>>
>>>> Please respond to this email with your sign-off, as described here:
>>>>
>>>> http://linuxtv.org/hg/v4l-dvb/file/tip/README.patches
>>>>
>>>> e) All patches shall have a Developers Certificate of Origin
>>>>
>>>>
>>>> Also, what software can people use with your device&  driver to tune
>>>> to DMB-TH services?
>>>>
>>>> How do users scan for services?
>>>>
>>>>          
>>> Dear Michael,
>>>
>>> Thanks for your hint on getting the patch accepted.  I've now cleaned
>>> up the patch to pass checkpatch.pl, and signed it off.
>>>
>>> I've also attached a second patch against the dvb-apps repository
>>> which adds a DMB-TH scan file for Hong Kong.  Since the ProHDTV stick
>>> contains a DMB-TH decoder (lgs8gl5) onboard, it outputs MPEG-TS to the
>>> PC.
>>>
>>> I've been using mplayer to test the driver.  But since I'm using
>>> dvb-usb's generic video streaming mechanism, I imagine the driver
>>> should be compatible with other DVB software.
>>>        
>> Timothy,
>>
>> I've applied your patch to my cxusb tree, with slight modifications, in
>> order to coincide with another patch to the same code.  Please test the
>> tree and confirm proper operation before I request a merge into the
>> master branch.
>>
>> http://linuxtv.org/hg/~mkrufky/cxusb
>>
>> I'll push the Hong Kong scan file to dvb-apps after this tree is merged
>> into the master branch.
>>
>> If you have any additional fixes / changes to make before this is merged
>> into master, please generate them against this cxusb tree.
>>      
>
> I also have a question--
>
> If the device is called, "Magic-Pro DMB-TH usb stick" then I think that we
> should change its name from "Conexant DMB-TH Stick" to "Magic-Pro DMB-TH usb stick"
>
> Which is the correct name?
>
> -Mike
>    
"Conexant..." is the name listed in the Windows INF file.  The circuit 
board appears to be a reference design branded by at least two companies 
(MagicPro and Mygica) in Hong Kong.

Regards,
Timohty

--------------090806010303030304090305
Content-Type: text/html; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit

<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
<html>
<head>
  <meta content="text/html; charset=ISO-8859-1"
 http-equiv="Content-Type">
  <title></title>
</head>
<body text="#000000" bgcolor="#ffffff">
Michael Krufky wrote:
<blockquote cite="mid:489F2D3C.6000002@linuxtv.org" type="cite">
  <pre wrap="">Michael Krufky wrote:
  </pre>
  <blockquote type="cite">
    <pre wrap="">Timothy Lee wrote:
    </pre>
    <blockquote type="cite">
      <pre wrap="">Michael Krufky wrote:
      </pre>
      <blockquote type="cite">
        <pre wrap="">Timothy Lee wrote:
 
        </pre>
        <blockquote type="cite">
          <pre wrap="">Attached is a patch against v4l-dvb repository to add support for
Magic-Pro DMB-TH usb stick.  DMB-TH is the HDTV broadcast standard used
in Hong Kong and China.

Regards,
Timothy Lee
    
          </pre>
        </blockquote>
        <pre wrap="">Timothy,

In order for your patch to be applied to the kernel, a sign-off is
required.

Please respond to this email with your sign-off, as described here:

<a class="moz-txt-link-freetext" href="http://linuxtv.org/hg/v4l-dvb/file/tip/README.patches">http://linuxtv.org/hg/v4l-dvb/file/tip/README.patches</a>

e) All patches shall have a Developers Certificate of Origin


Also, what software can people use with your device &amp; driver to tune
to DMB-TH services?

How do users scan for services?
  
        </pre>
      </blockquote>
      <pre wrap="">Dear Michael,

Thanks for your hint on getting the patch accepted.  I've now cleaned
up the patch to pass checkpatch.pl, and signed it off.

I've also attached a second patch against the dvb-apps repository
which adds a DMB-TH scan file for Hong Kong.  Since the ProHDTV stick
contains a DMB-TH decoder (lgs8gl5) onboard, it outputs MPEG-TS to the
PC.

I've been using mplayer to test the driver.  But since I'm using
dvb-usb's generic video streaming mechanism, I imagine the driver
should be compatible with other DVB software. 
      </pre>
    </blockquote>
    <pre wrap="">Timothy,

I've applied your patch to my cxusb tree, with slight modifications, in
order to coincide with another patch to the same code.  Please test the
tree and confirm proper operation before I request a merge into the
master branch.

<a class="moz-txt-link-freetext" href="http://linuxtv.org/hg/~mkrufky/cxusb">http://linuxtv.org/hg/~mkrufky/cxusb</a>

I'll push the Hong Kong scan file to dvb-apps after this tree is merged
into the master branch.

If you have any additional fixes / changes to make before this is merged
into master, please generate them against this cxusb tree.
    </pre>
  </blockquote>
  <pre wrap=""><!---->
I also have a question--

If the device is called, "Magic-Pro DMB-TH usb stick" then I think that we
should change its name from "Conexant DMB-TH Stick" to "Magic-Pro DMB-TH usb stick"

Which is the correct name?

-Mike
  </pre>
</blockquote>
"Conexant..." is the name listed in the Windows INF file.&nbsp; The circuit
board appears to be a reference design branded by at least two
companies (MagicPro and Mygica) in Hong Kong.<br>
<br>
Regards,<br>
Timohty<br>
</body>
</html>

--------------090806010303030304090305--


--===============1298459602==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
--===============1298459602==--
