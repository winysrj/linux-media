Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-ew0-f21.google.com ([209.85.219.21]:32865 "EHLO
	mail-ew0-f21.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751546AbZBMLhb convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 13 Feb 2009 06:37:31 -0500
Received: by ewy14 with SMTP id 14so967050ewy.13
        for <linux-media@vger.kernel.org>; Fri, 13 Feb 2009 03:37:29 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <acde52650902130335h5e747b96q2228731a8893f5a5@mail.gmail.com>
References: <acde52650902130335h5e747b96q2228731a8893f5a5@mail.gmail.com>
Date: Fri, 13 Feb 2009 12:37:29 +0100
Message-ID: <acde52650902130337x285a1cdbu27e18b9f87729646@mail.gmail.com>
Subject: DSMCC : How to add descriptors for PMT Generation into
	"psi-config.py" file ?
From: Mathieu Seguy <mathieu.seguy@telecom-bretagne.eu>
To: linux-media@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hello,
I would know how can I include a new descriptor into the PMT
declaration, in order to respect the French configuration.

That's is a piece (which is concerned by the modification) of the PMT :

 data_broadcast_id_descriptor(
       data_broadcast_ID = 10, # System Software Update
       ID_selector_bytes = '',
       ),

To respect French configuration, I need to add this descriptor into
the data_broadcast_id_descriptor :

System_software_update_info(){
    OUI_data_length
    for (i=0; i<N; i++){
      OUI
      reserved
      update_typeprofil étendu)
      reserved
      update_versioning_flag
      update_version
      selector_length
    }
}


But if I choose to modify the PMT like that :

data_broadcast_id_descriptor(
               data_broadcast_ID = 10, # System Software Update
               ID_selector_bytes = '',
               system_software_update_info = [
                   OUI = 0x00e064, # <<<<<<<<<<<<
                   update_type = 1,
               ]
           ),

I have the following error message:
File "./psi-config.py", line 261, in <module>    OUI_data_length( :
NameError: name 'OUI_data_length' is not defined

Or :
File "./psi-config.py", line 262    OUI = 0x00e064, # <<<<<<<<<<<<
   ^ SyntaxError: invalid syntax


How can I define my descriptor so ?

Thanks for any answer

Best regards

----------
Mathieu
Network Apprentice Engineer
